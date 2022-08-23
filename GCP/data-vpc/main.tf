terraform {
  backend "gcs" {
    bucket = "mylab123"
    prefix = "terraform/state/1"
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



data "google_compute_network" "my-network" {
  name = "network-0"
}

output name {
  value       = data.google_compute_network.my-network.id
}
