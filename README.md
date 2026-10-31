# NineSoft — NINE-9

**Current status (1 November 2026): Source upload and CI execution are blocked.** This GitHub repository is PUBLIC. The complete NineSoft accounting source is **not** hosted here. Do not deploy from this repository.

## Latest staging handoff

The owner has received the private source archive `NineSoft-Stage6-CI-Prepared-20261101.zip` in ChatGPT.

- SHA-256: `306ffcab06b7bfca9b41a23e5d522e0a422cd64c0c2613eafe48f83840ab905f`
- 654 files; Flutter + Laravel; accounting, weight/unit conversion, source, tests, CI workflows and Arabic documentation.
- Independent pure accounting checks passed locally; 176 PHP syntax checks passed.
- **Laravel integration tests:** not run (missing Composer/vendor and database drivers in the editing environment).
- **Flutter analyze/tests and APK/Windows/Web builds:** not run (Flutter, Dart, Android SDK and Windows runner are unavailable).
- **GitHub Actions:** not run here. Do not claim releases/artifacts exist.

## Safe next steps

1. The repository owner must change **Settings > General > Danger Zone > Change repository visibility > Private**. Do **not** upload proprietary source while public.
2. Extract the Stage6 ZIP into a separate working folder and run its `tools/verification/package_preflight.py` and other independent test scripts.
3. Use `tools/publish_staging_github.sh` (Linux/Git Bash) or `tools/publish_staging_github.ps1` (Windows) to import the complete sanitized source on **new branch** `staging/ninesoft-stage6-ci`. Both scripts refuse PUBLIC repositories and must not overwrite an existing branch.
4. Set a real isolated HTTPS GitHub Actions repository variable `NINESOFT_STAGING_API_BASE_URL` (a host labeled staging, stage, test, dev, sandbox, preview or qa). Production APIs and placeholders are forbidden.
5. The source includes GitHub Actions that run Laravel PHPUnit on SQLite and PostgreSQL plus Flutter analysis/tests. **Web/Android/Windows builds are gated on both test suites passing.** Retrieve actual downloadable artifacts only after CI succeeds.
6. Validate accounting, stock, conflict resolution, two-device sync and offline replays on staging. Production Hostinger deployment and database migrations require separate explicit authorization and verified backups.

Detailed directions are included privately within Stage6 ZIP: `CODEX_STAGE6_CI_HANDOFF_AR.md`, `STAGE6_CI_EXECUTION_AR.md`, `CHANGES_AR.md` and `VERIFICATION_STATUS.json`.

**No production system, Hostinger server or live financial database was changed in this stage.**
