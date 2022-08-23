
resource "google_compute_subnetwork" "cluster-subnet" {
  name          = "${var.vpc_name}-subnet"
  project       = var.project
  ip_cidr_range = var.ip_range
  network       = google_compute_network.gke-network.self_link
  region        = var.region


  secondary_ip_range {
    range_name    = "secondary-range"
    ip_cidr_range = var.secondary_ip_range
  }
}


resource "google_compute_network" "gke-network" {
  name                    = var.vpc_name
  project                 = var.project
  auto_create_subnetworks = false
}

