module "cloud_run" {
  source       = "./modules/cloud_run"
  project_id   = var.project_id
  region       = var.region
  service_name = var.service_name
  image        = var.image
  env_vars = {
    CHAT_WEBHOOK_URL = var.chat_webhook_url
    BILLING_TABLE    = var.billing_table
  }
}

module "scheduler" {
  source     = "./modules/scheduler"
  project_id = var.project_id
  region     = var.region
  job_name   = var.scheduler_job_name
  schedule   = var.schedule
  target_url = module.cloud_run.service_url
}

# Scheduler のサービスアカウントに Cloud Run への起動権限を付与
resource "google_cloud_run_service_iam_member" "scheduler_invoker" {
  project  = var.project_id
  location = var.region
  service  = module.cloud_run.service_name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${module.scheduler.service_account_email}"
}
