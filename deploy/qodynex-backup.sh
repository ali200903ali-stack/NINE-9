#!/usr/bin/env bash
set -Eeuo pipefail

required=(DATABASE_URL S3_ENDPOINT S3_BUCKET AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY)
for name in "${required[@]}"; do
  if [[ -z "${!name:-}" ]]; then
    echo "Missing required variable: $name" >&2
    exit 64
  fi
done

export AWS_DEFAULT_REGION="${S3_REGION:-auto}"
export AWS_EC2_METADATA_DISABLED=true
export AWS_CONFIG_FILE="${AWS_CONFIG_FILE:-/tmp/qodynex-aws-config}"
endpoint="${S3_ENDPOINT%/}"
aws configure set default.s3.addressing_style path

retention_days="${RETENTION_DAYS:-30}"
backup_prefix="${BACKUP_PREFIX:-postgres}"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
host_label="${RAILWAY_SERVICE_NAME:-qodynex-postgres}"
base="qodynex-${host_label}-${stamp}"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

dump="$work/${base}.dump"
toc="$work/${base}.toc.txt"
checksum="$work/${base}.sha256"
metadata="$work/${base}.json"

echo "Creating PostgreSQL logical backup at ${stamp}"
PGCONNECT_TIMEOUT=20 pg_dump "$DATABASE_URL" \
  --format=custom \
  --compress=9 \
  --no-owner \
  --no-privileges \
  --file="$dump"

pg_restore --list "$dump" > "$toc"
test -s "$dump"
test -s "$toc"
(
  cd "$work"
  sha256sum "$(basename "$dump")" "$(basename "$toc")" > "$(basename "$checksum")"
)

cat > "$metadata" <<JSON
{
  "application": "Qodynex Business",
  "kind": "postgresql-logical-backup",
  "createdAtUtc": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "postgresClientVersion": "$(pg_dump --version | sed 's/"/\\"/g')",
  "format": "custom",
  "compressionLevel": 9,
  "retentionDays": ${retention_days},
  "commit": "${RAILWAY_GIT_COMMIT_SHA:-unknown}"
}
JSON

put_object() {
  local file="$1"
  local key="$2"
  aws --endpoint-url "$endpoint" s3api put-object \
    --bucket "$S3_BUCKET" \
    --key "$key" \
    --body "$file" \
    --output json >/dev/null
  echo "Uploaded ${key}"
}

remote_prefix="${backup_prefix}/${stamp}"
put_object "$dump" "${remote_prefix}/$(basename "$dump")"
put_object "$toc" "${remote_prefix}/$(basename "$toc")"
put_object "$checksum" "${remote_prefix}/$(basename "$checksum")"
put_object "$metadata" "${remote_prefix}/$(basename "$metadata")"
put_object "$metadata" "${backup_prefix}/latest.json"

cutoff="$(date -u -d "-${retention_days} days" +%Y-%m-%dT%H:%M:%SZ)"
aws --endpoint-url "$endpoint" s3api list-objects-v2 \
  --bucket "$S3_BUCKET" \
  --prefix "${backup_prefix}/" \
  --output json \
| jq -r --arg cutoff "$cutoff" '.Contents[]? | select(.LastModified < $cutoff) | .Key' \
| while IFS= read -r key; do
    [[ -n "$key" && "$key" != "${backup_prefix}/latest.json" ]] || continue
    aws --endpoint-url "$endpoint" s3api delete-object \
      --bucket "$S3_BUCKET" \
      --key "$key" >/dev/null
    echo "Deleted expired object: $key"
  done

echo "Backup completed successfully: s3://${S3_BUCKET}/${remote_prefix}"
