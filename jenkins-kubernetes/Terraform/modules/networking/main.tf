# Revise vars.tf for vars

resource "google_compute_subnetwork" "kube-public-sub" {
  name          = "sub-kube-${var.student_name}-public"
  description = "Public subnetwork for Kubernetes clusters"
  ip_cidr_range = "10.9.1.0/24"
  region        = "${var.region}"
  network       = "${google_compute_network.kube-vpc_network.self_link}"
}

resource "google_compute_network" "kube-vpc_network" {
  name = "kube-${var.student_name}-vpc"
  description = "VPC network for Kubernetes clusters"
  auto_create_subnetworks = false
}