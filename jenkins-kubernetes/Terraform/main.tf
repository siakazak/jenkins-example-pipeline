# Revise variables.tf for vars

module "networking" {
  source = "./modules/networking"
  region = "${var.Region}"
}

module "firewall" {
  source = "./modules/firewall"
  vpc-name = "${module.networking.vpc-name}"
  host-ip = "${var.Host_ip}"
}

module "cluster" {
  source = "./modules/clusters"
  region = "${var.Region}"
  vpc-name = "${module.networking.vpc-name}"
  sub-vpc-name = "${module.networking.sub-vpc-public-name}"
  ref = "${var.Ref}"
  nodes_count = "${var.Nodes_count}"
}

provider "google" {
  credentials = "${file("./devops2020-kubernetes.json")}"
  project = "${var.Project}"
  region = "${var.Region}"
  version = "2.20"
}

output "= run the following script to deploy test app" {
  value = "\n./scripts/deploy.sh\n"
}
