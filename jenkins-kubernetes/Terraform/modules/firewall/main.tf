# Revise vars.tf for vars

resource "google_compute_firewall" "firewall-kube" {
  name    = "${var.FirewallName}-kube"
  network = "${var.vpc-name}"
  description = "Kubernetes Firewall rules"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["0-65535"]
  }

  target_tags = [ "kubernetes" ]
  source_tags = [ "kubernetes" ]
}

resource "google_compute_firewall" "firewall-external" {
  name    = "${var.FirewallName}-kube-ext"
  network = "${var.vpc-name}"
  description = "Kubernetes Firewall rules"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["0-65535"]
  }
  source_ranges = ["${var.host-ip}"]
}