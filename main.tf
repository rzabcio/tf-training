terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

variable app_engine { }
variable bucket { }
variable project { }
variable region { }
variable zone { }

provider "google" {
  credentials = file("sa-terraform-key.json")
  project = var.project.name
  region  = var.region
  zone    = var.zone
}

variable "services" {
  type = list(string)
  default = ["appengine.googleapis.com", "cloudresourcemanager.googleapis.com"]
}

resource "google_project_service" "service" {
  for_each = toset(var.services)
  project = var.project.id
  service = each.value
  timeouts {
    create = "30m"
    update = "40m"
  }
  disable_on_destroy = true
  disable_dependent_services = true
}

resource "google_app_engine_application" "frontend" {
  project     = var.project.id
  location_id = var.app_engine.location
}

resource "google_storage_bucket" "bucket" {
  name     = var.bucket.name
  project  = var.project.id
  location = var.app_engine.location
}

resource "google_storage_bucket_object" "frontend_object" {
  name   = var.bucket.frontend_zip
  bucket = google_storage_bucket.bucket.name
  source = "go-frontend/go-frontend.zip"
}
