variable "project_id" {
  description = "GCPのプロジェクトID"
  type        = string
}

variable "region" {
  description = "デプロイするリージョン"
  type        = string
}

variable "service_name" {
  description = "Cloud Run サービス名"
  type        = string
}

variable "image" {
  description = "デプロイするコンテナイメージ"
  type        = string
}

variable "env_vars" {
  description = "コンテナに渡す環境変数のマップ"
  type        = map(string)
}
