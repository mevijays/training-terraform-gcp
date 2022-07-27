terraform {
  backend "gcs" {
    bucket = "krlab"
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
  default     = "krlab-012"
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
  credentials = file("krlab-012-09334ebda940.json")
}


# VPC creation without subnet
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# VPC creation with default auto subnet all region
resource "google_compute_network" "vpc1" {
  name                    = "${var.project_id}-vpc1"
  auto_create_subnetworks = "true"
}