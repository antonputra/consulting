resource "google_service_account" "prometheus_ui" {
  project    = google_project.this.project_id
  account_id = "prometheus-ui"
}

resource "google_service_account_iam_member" "prometheus_ui" {
  service_account_id = google_service_account.prometheus_ui.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${local.project_id}.svc.id.goog[gmp-monitoring/prometheus-ui]"

  depends_on = [google_container_cluster.this]
}

resource "google_project_iam_member" "prometheus_ui" {
  project = google_project.this.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.prometheus_ui.email}"

  depends_on = [google_service_account.prometheus_ui]
}
