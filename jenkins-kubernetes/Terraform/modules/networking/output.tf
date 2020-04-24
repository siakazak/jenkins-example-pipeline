output "vpc-self_link" {
  value = "${google_compute_network.kube-vpc_network.self_link}"
}

output "vpc-name" {
  value = "${google_compute_network.kube-vpc_network.name}"
}

output "sub-vpc-public-self_link" {
  value = "${google_compute_subnetwork.kube-public-sub.self_link}"
}

output "sub-vpc-public-name" {
  value = "${google_compute_subnetwork.kube-public-sub.name}"
}