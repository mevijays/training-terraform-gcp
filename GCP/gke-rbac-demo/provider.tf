
provider "google" {
  project = var.project
  zone    = var.zone
}

// Pins the version of the "random" provider
provider "random" {
}

// Pins the version of the "template" provider
provider "template" {
}

// Pins the version of the "null" provider
provider "null" {
}

