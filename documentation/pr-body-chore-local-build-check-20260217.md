# PR Title
feat: add configurable time offset and rename app to Aerial_masatomo

# Summary
- Add a configurable clock offset (`timeOffsetMinutes`) so displayed time can be shifted (e.g. +10 minutes).
- Add UI input for time offset in Time & Location settings.
- Apply the offset to on-screen clock rendering.
- Rename app/product/executable naming to `Aerial_masatomo`.

# Changes
1. Time offset setting
- Add default config value in `app.js`:
  - `timeOffsetMinutes` default: `0`
- Add config UI in `web/config.html`:
  - `Displayed time offset` (number input, minutes)
- Wire setting persistence in `web/config.js`.
- Apply offset to displayed clock in `web/screensaver.js`:
  - `moment().add(offsetMinutes, 'minutes')`

2. Naming update
- Update package name in `package.json`:
  - `name: aerial_masatomo`
- Update product name for packaged app in `package.json`:
  - `build.productName: Aerial_masatomo`
- Update portable artifact name in `package.json`:
  - `build.portable.artifactName: Aerial_masatomo.exe`
- Sync lockfile package name in `package-lock.json`.
- Update AutoLaunch app name in `app.js` to `Aerial_masatomo`.

# Build / Verification
1. `npm ci` completed successfully
2. `npm run build` completed successfully

Generated artifacts:
- `dist/Aerial_masatomo Setup 1.2.1.exe`
- `dist/win-unpacked/Aerial_masatomo.exe`

# Branch
- `chore/local-build-check-20260217`

# Commit
- `2bc0f90 feat: add time offset setting and rename app to Aerial_masatomo`
