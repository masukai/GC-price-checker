# Codex コーディング環境セットアップガイド

このドキュメントでは、OpenAI Codex による自動コーディングを行う際に `.codex/setup.sh` がどのような環境準備を行うかを説明します。
ローカル開発者向けのセットアップではなく、Codex のワークスペースで不足しがちなツールのみを補うことを目的としています。

## 方針

- Codex が標準で用意しているツール (Python や pip など) を再インストールすることはありません。
- Terraform など、Codex 環境に含まれない可能性が高いツールだけを追加します。
- Python の依存関係は `requirements.txt` を元に毎回同期し、スクリプト実行直後からテストを行えるようにします。

## 実行手順

Codex がタスクを開始すると自動的に `.codex/setup.sh` を実行します。手動で確認したい場合は、リポジトリのルートで次のコマンドを実行してください。

```bash
cd /path/to/GC-price-checker
./.codex/setup.sh
```

## スクリプトの処理内容

`.codex/setup.sh` は以下の順序で処理を行います。

1. `apt-get` が利用できる場合に限り、Codex 環境に存在しない可能性があるシステムパッケージを確認します。
   不足しているものだけを追加インストールします。
   - `ca-certificates`
   - `curl`
   - `gnupg`
   - `lsb-release`
   - `python3`
   - `python3-pip`
2. Terraform がインストールされていない場合は、HashiCorp の公式リポジトリを追加して Terraform を導入します。
3. `pip` を最新化し、`requirements.txt` に記載された依存関係をインストールします。

## トラブルシューティング

- Codex 以外の環境でスクリプトを実行する場合、`apt-get` が利用できるか確認してください。
- プロキシ経由での通信が必要な場合は、`curl` が外部サイトへアクセスできるよう環境変数を設定してから再実行してください。
- Terraform を独自に管理している環境では、スクリプトが新しいリポジトリを追加する点に注意してください。

## 参考情報

- Terraform: <https://developer.hashicorp.com/terraform>
- Cloud Run: <https://cloud.google.com/run>
- Cloud Scheduler: <https://cloud.google.com/scheduler>
