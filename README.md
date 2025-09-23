# GC Price Checker

このリポジトリは、Google Cloud の料金を日次で取得し、Google Chat に通知する仕組みを構築するためのサンプルです。
Cloud Run 上で Python アプリケーションを実行し、Cloud Scheduler によって毎日実行されます。
Terraform によりインフラをコード化し、workspace を利用して複数環境を管理します。

## 構成

- **Cloud Run**: BigQuery から前日の料金を集計し、Google Chat Webhook へ送信します。
- **Cloud Scheduler**: Cron スケジュールに従い Cloud Run サービスを HTTP で呼び出します。
- **Terraform**: module 単位で Cloud Run と Scheduler を定義しています。

## 事前準備

1. BigQuery で課金エクスポートを有効化し、テーブルを作成しておきます。
2. Google Chat で受信Webhook URL を作成します。
3. 各環境用のサービスアカウント鍵(JSON)を用意します。

## 使い方

### コンテナイメージのビルド

```bash
docker build -t gcr.io/PROJECT_ID/gcp-cost-notifier:latest .
docker push gcr.io/PROJECT_ID/gcp-cost-notifier:latest
```

### Terraform の初期設定

1. `terraform/credentials.tf.example` を `terraform/credentials.tf` にコピーし、
   変数 `credentials_file` にサービスアカウント鍵のパスを指定してください。
2. `terraform/env/dev.tfvars.example` などを参考に、各環境用の `tfvars` ファイルを作成します。
   これらのファイルには `project_id` や `image`、`chat_webhook_url` などを設定します。

### 環境ごとのデプロイ

```bash
cd terraform
terraform init
terraform workspace new dev   # 初回のみ
terraform workspace select dev
terraform apply -var-file=env/dev.tfvars
```

別の環境をデプロイする場合は workspace を切り替え、対応する `tfvars` ファイルを指定してください。

## ファイル構成

```text
app/                Python アプリケーション
terraform/          Terraform 定義
  modules/          Cloud Run と Scheduler のモジュール
  env/              環境ごとの変数ファイル (例)
```

## 注意事項

- `terraform/credentials.tf` や実際の `tfvars` ファイルには機密情報が含まれるため、
  `.gitignore` によりリポジトリには含めないようにしています。
- 実環境で利用する際は、必要な IAM 権限や API の有効化を行ってください。

