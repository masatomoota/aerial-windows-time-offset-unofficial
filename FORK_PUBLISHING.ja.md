# フォーク公開チェックリスト

このリポジトリは `OrangeJedi/Aerial` の非公式フォークとして公開することを想定しています。

## 推奨リポジトリ名
- 表示名: `Aerial for Windows Time Offset (Unofficial)`
- GitHub リポジトリ名（slug）例: `aerial-windows-time-offset-unofficial`

注意: GitHub のリポジトリ名にはスペースを使えません。

## GitHub 設定
1. GitHub Fork のまま運用する（特別な理由がない限り親子関係を外さない）。
2. 説明文を明確にする。例:
   - `Unofficial fork of OrangeJedi/Aerial with configurable time offset display support.`
3. バイナリを公開配布するなら visibility は `Public` にする。
4. フォーク側で問い合わせを受けるなら `Issues` を有効にする。

## 必須ドキュメント
1. 上流MITライセンス本文と帰属表示（`LICENSE`）を維持する。
2. `README.md` にフォークであることと上流リンクを明記する。
3. `NOTICE.md` で帰属とフォーク範囲を明記する。
4. 各リリースノートに次を記載する:
   - ベースにした上流バージョン/コミット
   - フォーク固有の変更点
   - 上流との差分による既知の挙動差

## 上流同期の運用
1. `upstream` リモートを保持する: `https://github.com/OrangeJedi/Aerial.git`
2. 定期的に上流を fetch し、意図を持って merge/rebase する。
3. フォーク独自仕様のために解消した競合は記録を残す。

### 1コマンド同期ヘルパー
`origin/master` から上流同期用ブランチを分け、分離された worktree で取り込むスクリプトを使えます。

```bash
scripts/sync_upstream.sh --push
```

- 既定ブランチ名: `chore/sync-upstream-YYYYMMDD`
- 競合が出た場合は一時 worktree を保持し、解消手順を表示します。
