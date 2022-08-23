terraform {
  backend "gcs" {
    bucket = "mylab123"
    prefix = "terraform/state/gcs"
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
// declare the variable for bucket name 
variable bucket_name {
  type        = string
  default     = "ex2-gcs"
  description = "bucket name"
}

# provider definition and config
provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("../../gcp-terraform-key.json")
}

resource "google_storage_bucket" "my_bucket" {
name     = var.bucket_name
location = var.region
}

resource "google_storage_bucket_object" "fileupload" {
  name   = "file-1"
  content = "Hello thi sis file content!"
  bucket = var.bucket_name
  depends_on = [
    google_storage_bucket.my_bucket
  ]
}
