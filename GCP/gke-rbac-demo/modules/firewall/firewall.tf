resource "google_compute_firewall" "bastion-ssh" {
  name          = "gke-demo-bastion-fw-rbac"
  network       = var.vpc_name
  direction     = "INGRESS"
  project       = var.project
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = var.net_tags
}

