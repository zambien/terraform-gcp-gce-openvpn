variable "google_project" {
  default = "terraform-gcp-gce-openvpn"
}

variable "prefix" {
  default = "openvpn"
}

variable "region" {
  default = "us-east1"
}

variable "endpoint_cn" {
  default = "vpn.my.com"
}

variable "cluster_master_username" {}
variable "cluster_master_password" {}

# Configure the Google Cloud provider
provider "google" {
  credentials = "${file("~/.gcp/${var.google_project}.json")}"
  project     = "${var.google_project}"
  region      = "${var.region}"
}

# Enable APIs for project so terraform can do it's thing
resource "google_project_services" "openvpn_project" {
  project = "${var.google_project}"

  services = [
    "iam.googleapis.com",
    "compute-component.googleapis.com",
    "container.googleapis.com",
    "servicemanagement.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "storage-api.googleapis.com",
    "dns.googleapis.com"
  ]
}

resource "google_compute_network" "openvpn_network" {
  name                    = "${var.prefix}-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "openvpn_subnet" {
  name          = "${var.prefix}-subnet"
  ip_cidr_range = "10.0.2.0/24"
  network       = "${google_compute_network.openvpn_network.self_link}"
  region        = "${var.region}"
}

resource "google_compute_firewall" "openvpn_fw" {
  name    = "${var.prefix}-fw"
  network = "${google_compute_network.openvpn_network.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "1194"]
  }

  source_ranges = ["0.0.0.0/0"]
}

module "pki_service" {
  source          = "modules/pki_service"
  #endpoint_server = "${google_compute_global_address.openvpn_ingress.address}"
  endpoint_server = "${var.endpoint_cn}"
}

