terraform {
  backend "gcs" {
    bucket = "gks-gke"
    prefix = "tf/state/gke"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.33.0"
    }
  }
}
provider "random" {
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("./terraform-sa.key")
}
