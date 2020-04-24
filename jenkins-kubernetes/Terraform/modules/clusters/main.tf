resource "google_container_cluster" "primary" {
  name     = "${var.ref}"
  location = "${var.region}-a"
  network = "${var.vpc-name}"
  subnetwork  = "${var.sub-vpc-name}"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${var.ref}-pool"
  location   = "${var.region}-a"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = "${var.nodes_count}"

  node_config {
    preemptible  = true
    machine_type = "n1-standard-2"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      ref = "${var.ref}"
    }

    tags = ["${var.ref}", "kubernetes"]

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}