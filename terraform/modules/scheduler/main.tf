# Cloud Scheduler用サービスアカウント
resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = "${var.job_name}-sa"
  display_name = "${var.job_name} scheduler service account"
}

# Cloud Scheduler ジョブを作成
resource "google_cloud_scheduler_job" "job" {
  name        = var.job_name
  project     = var.project_id
  region      = var.region
  schedule    = var.schedule
  time_zone   = "Asia/Tokyo"

  http_target {
    uri        = var.target_url
    http_method = "POST"
    oidc_token {
      service_account_email = google_service_account.sa.email
    }
  }
}
