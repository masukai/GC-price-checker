variable "project_id" {
  description = "GCPのプロジェクトID"
  type        = string
}

variable "region" {
  description = "リソースを作成するリージョン"
  type        = string
}

variable "service_name" {
  description = "Cloud Run サービス名"
  type        = string
  default     = "gcp-cost-notifier"
}

variable "image" {
  description = "Cloud Run にデプロイするコンテナイメージ"
  type        = string
}

variable "chat_webhook_url" {
  description = "Google Chat のWebhook URL"
  type        = string
}

variable "billing_table" {
  description = "BigQuery 課金エクスポートテーブル名"
  type        = string
}

variable "scheduler_job_name" {
  description = "Cloud Scheduler ジョブ名"
  type        = string
  default     = "gcp-cost-notifier-job"
}

variable "schedule" {
  description = "Cloud Scheduler のCronスケジュール"
  type        = string
  default     = "0 9 * * *"
}

variable "credentials_file" {
  description = "サービスアカウント鍵ファイルへのパス"
  type        = string
}
