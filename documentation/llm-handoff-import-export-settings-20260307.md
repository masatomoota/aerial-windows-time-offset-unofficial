# LLM Handoff: Import/Export Settings Feature

## Snapshot
- Repository: `Aerial`
- Branch: `chore/local-build-check-20260217`
- Date: 2026-03-07
- Feature status: implemented and Windows build verified

## User-facing outcome
- Added a way to import settings from another installed Aerial instance.
- Added a way to export the current settings to another installed Aerial instance.
- Both actions are exposed in `Settings > Advanced > Import / Export Settings`.

## Implementation summary

### Main process
- File: `app.js`
- Added `IMPORT_SETTINGS_EXCLUDED_KEYS` to avoid copying install-local state.
- Added discovery of other installed Aerial config files from `app.getPath('appData')`.
- Added `getTransferableSettingsSnapshot()` to capture only portable settings.
- Added `importSettingsFromConfigFile(configPath)`.
- Added `exportSettingsToConfigFile(configPath)`.
- Added IPC handlers:
  - `listImportableConfigs`
  - `importSettingsFromConfig`
  - `exportSettingsToConfig`
- Reused `syncAstronomyToStore()` so exported/imported sunrise/sunset related data is normalized.
- Fixed a pre-existing bug in `updateCustomVideos()` where invalid custom video IDs were removed with the wrong index.

### Preload
- File: `preload.js`
- Extended `ipcRenderer.invoke` allowlist with:
  - `listImportableConfigs`
  - `importSettingsFromConfig`
  - `exportSettingsToConfig`

### Renderer / UI
- Files:
  - `web/config.html`
  - `web/config.js`
- Added a new Advanced section:
  - source selector
  - refresh button
  - import button
  - export button
- Added renderer logic to:
  - load candidate installs
  - display target config path and timestamp
  - run import/export with confirmation dialogs
  - refresh the settings screen after import

## Data transfer rules

### Intentionally excluded from transfer
- `astronomy`
- `cachePath`
- `configured`
- `downloadedVideos`
- `numDisplays`
- `updateAvailable`
- `version`
- `videoCacheSize`

### Transfer model
- Import:
  - load target `config.json`
  - merge transferable keys into the current store
  - run existing config normalization/setup logic
- Export:
  - snapshot current transferable settings
  - merge them into the selected target `config.json`
  - preserve target-local cache/state keys

## Validation performed
- Syntax checks:
  - `node --check app.js`
  - `node --check preload.js`
  - `node --check web/config.js`
- Build checks:
  - WSL command `npm run build` failed because `electron-builder` tried Linux packaging and hit `unknown output format set`.
  - Windows-native build succeeded with:
    - `cmd.exe /c "cd /d C:\Users\masatomo\_git_repository\Aerial && npm run build"`

## Verified build artifacts
- `dist/Aerial_masatomo Setup 1.2.1.exe`
- `dist/Aerial_masatomo Setup 1.2.1.exe.blockmap`
- `dist/win-unpacked/Aerial_masatomo.exe`

Artifact timestamps observed:
- `2026-03-07 14:33:44 +0900` `dist/Aerial_masatomo Setup 1.2.1.exe`
- `2026-03-07 14:33:46 +0900` `dist/Aerial_masatomo Setup 1.2.1.exe.blockmap`
- `2026-03-07 14:33:33 +0900` `dist/win-unpacked/Aerial_masatomo.exe`

## Files changed for this feature
- `app.js`
- `preload.js`
- `web/config.html`
- `web/config.js`
- `documentation/import-export-settings-user-manual.ja.md`
- `documentation/llm-handoff-import-export-settings-20260307.md`

## Operational notes
- Candidate installs are discovered by scanning AppData directories whose names match `/aerial/i` and contain `config.json`.
- The current install is excluded from both import and export candidates.
- Export updates the target config file directly; if the target Aerial is already running, it should be restarted manually.
- Import updates the current store immediately and refreshes the config screen.

## Resume instructions
1. Check `git status --short`.
2. Re-run Windows build with `cmd.exe` if packaging validation is needed.
3. If further UX polish is needed, work from the Advanced section in `web/config.html` and `web/config.js`.
4. If transfer rules change, update `IMPORT_SETTINGS_EXCLUDED_KEYS` in `app.js` first.

## Suggested next checks
1. Manual UI test on a machine with at least two Aerial config directories in AppData.
2. Verify custom video paths remain valid when importing from another install.
3. Consider whether export/import should support arbitrary file picking in addition to auto-detected installs.
