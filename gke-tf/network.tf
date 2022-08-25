//random string
resource "random_id" "randhex" {
  byte_length = 2
}

// creating GKE  VPC
resource "google_compute_network" "gke_vpc" {
  project                 = var.project_id
  name                    = "gke-vpc-${random_id.randhex.hex}"
  auto_create_subnetworks = false
  mtu                     = 1460
}

// subnetworks 
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.node_cidr
  region        = var.region
  network       = google_compute_network.gke_vpc.id
  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = var.pod_cidr
  }
  secondary_ip_range {
    range_name    = "services-ranges"
    ip_cidr_range = var.svc_cidr
  }
  dynamic "log_config" {
    for_each = var.enable_netlog ? [1] : []
    content {
      aggregation_interval = "INTERVAL_10_MIN"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }
  private_ip_google_access = var.enable_private
}
//Creating a cloud DNS zone

resource "google_dns_managed_zone" "private-zone" {
  name       = var.dns_zone_name
  dns_name   = "${var.dns_zone_prefix}.vodafone.com."
  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.gke_vpc.id
    }
  }
}
// cloud router setup for private gke node
resource "google_compute_router" "router" {
  name    = "gke-rt-${random_id.randhex.hex}"
  region  = var.region
  network = google_compute_network.gke_vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "gke-rt-nat-${random_id.randhex.hex}"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}