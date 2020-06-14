output ws-pedigree-service-url {
  description = "Url to cloud run service"
  value = google_cloud_run_service.default.status[0].url
}