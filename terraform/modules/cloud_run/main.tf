# Cloud Run サービス用のサービスアカウントを作成
resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = "${var.service_name}-sa"
  display_name = "${var.service_name} service account"
}

# Cloud Run サービスを作成
resource "google_cloud_run_service" "service" {
  name     = var.service_name
  project  = var.project_id
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.sa.email
      containers {
        image = var.image
        env = [for k, v in var.env_vars : {
          name  = k
          value = v
        }]
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
