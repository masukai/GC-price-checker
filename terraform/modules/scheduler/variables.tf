variable "project_id" {
  description = "GCPのプロジェクトID"
  type        = string
}

variable "region" {
  description = "ジョブを作成するリージョン"
  type        = string
}

variable "job_name" {
  description = "Cloud Scheduler ジョブ名"
  type        = string
}

variable "schedule" {
  description = "Cron 形式のスケジュール"
  type        = string
}

variable "target_url" {
  description = "呼び出すHTTPターゲットのURL"
  type        = string
}
