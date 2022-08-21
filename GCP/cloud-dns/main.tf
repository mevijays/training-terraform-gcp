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

/*
resource "google_dns_managed_zone" "private-zone" {
  name        = "private-zone"
  dns_name    = "private.example.com."
  description = "Example private DNS zone"
  labels = {
    foo = "bar"
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.network[0].id
    }
    networks {
      network_url = google_compute_network.network[1].id
    }
  }
}
*/
/*
resource "google_dns_managed_zone" "private-zone" {
  name        = "private-zone"
  dns_name    = "private.example.com."
  description = "Example private DNS zone"
  labels = {
    foo = "bar"
  }

  visibility = "private"

  private_visibility_config {
    dynamic "networks" {
        for_each = google_compute_network.network[*].id
        content {
            network_url = google_compute_network.network[networks.key].id
        }
    }
   }
}

resource "google_compute_network" "network" {
  count                   = 2
  name                    = "network-${count.index}"
  auto_create_subnetworks = false
}
