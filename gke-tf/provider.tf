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

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("krlab-012-09334ebda940.json")
}