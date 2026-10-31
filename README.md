# NineSoft — NINE-9

**Status (31 Oct 2026):** The full application source has **NOT** been pushed to this repository. No Android/Windows/Web build has run here, and this repository is **not deployment-ready**.

## Latest trial source package (delivered privately to the owner)
- `NineSoft-Stage5-Weight-UI-Review-20261031.zip`
- SHA-256: `dbb7e8e23b17ff07f2888cdd77ccf31ba10f48f43bf260797f95a4296f3d70ca`
- Files: 649 (Flutter, Laravel, Arabic docs, tests, and CI workflows).
- Includes the owner's reference entry UI, unit conversion (1kg=1000g), cashier **sell by amount** (500 YER amount input), ledger-safe stock deduction, the Web **Update Release** button (does not clear IndexedDB/localStorage/offline queues), and accounting fixes from earlier stages.
- This ZIP is attached to the owner's ChatGPT conversation, **not** publicly accessible from GitHub.

## Next operations for Codex
1. Receive and extract the full Stage5 ZIP, review `CHANGES_AR.md`, `STAGE5_TEST_RESULTS_AR.md`, and `CODEX_FINAL_HANDOFF_AR.md`.
2. **Make this repository Private** before uploading the company's proprietary source/assets. Do not upload live .env, keys, or customer databases.
3. Run `tools/publish_staging_github.sh` after GitHub CLI login; the script refuses public repositories and existing staging branches. It pushes only to `staging/ninesoft-stage5`.
4. Configure a separate `NINESOFT_STAGING_API_BASE_URL` repository variable (HTTPS, NEVER the production API). Run and fix GitHub Actions: `accounting-integrity.yml` (SQLite + PostgreSQL) and `flutter-ci.yml` (Flutter analyze/tests, Web/Windows/Android builds).
5. Validate the full financial cycle on staging, including old data, outbox retries, two devices, stock and journal balances, 500 YER weighed item, and browser cache update with offline data retained.
6. **Do not merge or deploy to the live Hostinger server or database without explicit separate authorization** and proven backup/restore.

**Verified locally:** PHP syntax 176 files; pure accounting checks, weight conversions, static checks, and Node mock browser update. **NOT verified:** full Laravel DB suite; Flutter analysis/tests; APK/EXE/Web builds or cross-device sync. Do not describe the trial as production-ready.
