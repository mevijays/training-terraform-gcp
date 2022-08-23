resource "random_string" "role_suffix" {
  length  = 8
  special = false
}


resource "google_project_iam_custom_role" "kube-api-ro" {
  role_id = "kube_api_ro_${random_string.role_suffix.result}"

  title       = "Kubernetes API (RO)"
  description = "Grants read-only API access that can be further restricted with RBAC"

  permissions = [
    "container.apiServices.get",
    "container.apiServices.list",
    "container.clusters.get",
    "container.clusters.getCredentials",
  ]
}

resource "google_service_account" "owner" {
  account_id   = "gke-tutorial-owner-rbac"
  display_name = "GKE Tutorial Owner RBAC"
}

resource "google_service_account" "auditor" {
  account_id   = "gke-tutorial-auditor-rbac"
  display_name = "GKE Tutorial Auditor RBAC"
}

resource "google_service_account" "admin" {
  account_id   = "gke-tutorial-admin-rbac"
  display_name = "GKE Tutorial Admin RBAC"
}

resource "google_project_iam_binding" "kube-api-ro" {
  role = "projects/${var.project}/roles/${google_project_iam_custom_role.kube-api-ro.role_id}"

  members = [
    "serviceAccount:${google_service_account.owner.email}",
    "serviceAccount:${google_service_account.auditor.email}",
  ]
}

resource "google_project_iam_member" "kube-api-admin" {
  project = var.project
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.admin.email}"
}

