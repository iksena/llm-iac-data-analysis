# Create a VPC access connector
# This will create a group of machines which bridge traffic between serverless services (such as Cloud Functions)
#   and anything else within the VPC (for example DB instances)
#
# The connector will automatically also create firewall rules that allow traffic between the
#   connector machines and the rest of the VPC; this rule will not be visible within Google Cloud
# Reference: https://cloud.google.com/vpc/docs/serverless-vpc-access#firewall_rules
resource "google_vpc_access_connector" "connector" {
  name          = var.serverless_vpc_connector_name
  ip_cidr_range = var.serverless_vpc_connector_ip_cidr_range
  network       = google_compute_network.private_network.name

  # Machine type + number of instances affects both throughput and price
  # Reference: https://cloud.google.com/vpc/docs/serverless-vpc-access#scaling
  #
  # These options are still in Beta in the google v4.0.0; consider upgrading to google 4.43.0
  #
  # machine_type = "e2-micro"
  # min_instances = 2
  # max_instances = 2

  region = var.serverless_vpc_connector_region
}