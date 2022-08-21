terraform {
  backend "gcs" {
    bucket = "mylab123"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.30.0"
    }
  }
}

# declare a vriable for region and project id
variable "project_id" {
  default     = "project-dev-355909"
  description = "project id"
}

variable "region" {
  default     = "us-central1"
  description = "region"
}

# provider definition and config
provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("../../gcp-terraform-key.json")
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc.id
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.0.0/16"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "172.16.0.0/16"
  }
}
// firewall
resource "google_compute_firewall" "firewall" {
  name    = "vijay-firewall-externalssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"] # Not So Secure. Limit the Source Range
  target_tags   = ["externalssh"]
}
// VM instance
resource "google_service_account" "default" {
  account_id   = "first-compute"
  display_name = "Service Account"
}
resource "google_compute_address" "static" {
   name    = "devserver-ip"
   project = var.project_id
   region  = var.region
}
resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  tags = ["externalssh", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
      // Ephemeral public IP if want static use bellow
      nat_ip = google_compute_address.static.address
    }
  }

  metadata = {
    ssh-keys = "vijay:${file("~/.ssh/id_rsa.pub")}"
  }

  metadata_startup_script = "echo hi > /test.txt"
  provisioner "local-exec" {
    command = "echo ${self.network_interface[0].network_ip}"
  }
  

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

}
