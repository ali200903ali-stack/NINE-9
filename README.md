# NineSoft — NINE-9

**Repository status: initialization / staging handoff only.** The complete application source has **not yet been pushed** here. Do not treat this repository as a working accounting system or deploy it to production.

## Source package prepared on 31 October 2026
- Base: NineSoft `0.29.27+75` (Flutter + Laravel).
- Trial source ZIP: `NineSoft-Stage2-Source-Trial-20261031.zip`, delivered in the owner's ChatGPT conversation (not publicly hosted).
- The ZIP contains 607 source/project files, with 12 modified and 10 new files.
- SHA-256 (full trial ZIP): `4362f6d89159b1d95ca25351204df7d86e0b414f9c3c4ba4dc58100bb87b6d1a`. See `STAGING_STATUS_AR.md` for exact current state.
- Contents: original project layout, `CHANGES_AR.md`, `BUILD_AND_TEST_AR.md`, purchase outbox and tests, GitHub Actions workflows.
- No live Hostinger server, production database or production credentials were changed or accessed during this correction.

## Import the complete source ZIP
Download the ZIP attachment from the ChatGPT conversation and **extract its contents into the repository root** (so `apps/`, `services/` and `.github/` are at the top level). Run the bundled preflight checker:

```bash
python3 tools/verification/package_preflight.py
cd services/api
php tests/accounting_core_smoke.php
php tests/purchase_request_fingerprint_smoke.php
python3 tests/verify_exact_math.py
```

Before uploading, review changed files for credentials, customer records and unintended binaries. Note this repository is **public**. After the complete source is imported, verify Flutter and Laravel CI on isolated staging environments.

## Build requirements
- Flutter project: `apps/nizami_app`. Run `flutter pub get && flutter analyze --fatal-infos && flutter test`.
- Laravel project: `services/api`. Run `composer install` then `php artisan test` with **test database only**.
- GitHub Actions: set repository variable `NINESOFT_STAGING_API_BASE_URL` to an isolated HTTPS staging API URL. The trial workflow must not target `ninesoft.qodynex.tech`.
- Real Windows / Android / Web binaries have **not** yet been built in the editing environment.

Do not deploy or migrate a live database from this partial repository. Use the bundled `CHANGES_AR.md` for verified tests and unresolved critical tasks after importing the full source.
