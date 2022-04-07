terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("sa-terraform-key.json")

  project = "training-vms-331821"
  region  = "eu-central2"
  zone    = "eu-central2-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
