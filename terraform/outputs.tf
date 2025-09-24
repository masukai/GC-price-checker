output "cloud_run_url" {
  description = "Cloud Run サービスのURL"
  value       = module.cloud_run.service_url
}
