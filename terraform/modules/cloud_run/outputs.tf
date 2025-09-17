output "service_url" {
  description = "デプロイされたCloud RunサービスのURL"
  value       = google_cloud_run_service.service.status[0].url
}

output "service_name" {
  description = "Cloud Run サービス名"
  value       = google_cloud_run_service.service.name
}

output "service_account_email" {
  description = "Cloud Run サービスアカウントのメールアドレス"
  value       = google_service_account.sa.email
}
