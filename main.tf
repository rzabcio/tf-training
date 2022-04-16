terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

variable project { }
variable bucket { }
variable frontend_app { }

provider "google" {
  credentials = file("sa-terraform-key.json")
  project = var.project.id
  region  = var.project.region
  zone    = var.project.zone
}

resource "google_project_service" "service" {
  for_each         = toset(var.project.services)
  project          = var.project.id
  service          = each.value
  timeouts {
    create = "30m"
    update = "40m"
  }
  disable_on_destroy = true
  disable_dependent_services = true
}

resource "google_app_engine_application" "frontend" {
  project          = var.project.id
  location_id      = var.frontend_app.location
}

resource "google_storage_bucket" "bucket" {
  name             = "${var.project.id}-${var.bucket.name}"
  project          = var.project.id
  location         = var.frontend_app.location
}

data "archive_file" "frontend_zip" {
  type             = "zip"
  output_path      = var.frontend_app.zip
  source_dir       = "go-frontend"
}

resource "google_storage_bucket_object" "frontend_object" {
  name             = var.frontend_app.zip
  bucket           = google_storage_bucket.bucket.name
  source           = var.frontend_app.zip
}

resource "google_app_engine_standard_app_version" "frontend_app" {
  version_id = var.frontend_app.version_id
  service    = var.frontend_app.service
  runtime    = var.frontend_app.runtime

  entrypoint {
    shell    = "go run main.go"
    /* shell    = "main" */
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.frontend_object.name}"
    }
  }

  noop_on_destroy = true
}
