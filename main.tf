terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

variable project { }
variable region { }
variable zone { }
variable app_engine { }

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
