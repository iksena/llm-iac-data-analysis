output "vpc_id" {
  value       = google_compute_network.this.id
  description = "string || The ID of the created VPC in the form 'projects/(project-id)/global/networks/(vpc-name)'."
}

output "vpc_name" {
  value       = local.resource_name
  description = "string ||| The name of the created VPC."
}

output "public_subnet_names" {
  value       = google_compute_subnetwork.public.*.name
  description = "list(string) ||| The names of the public subnets"
}

output "public_subnets_ids" {
  value       = google_compute_subnetwork.public.*.id
  description = "list(string) ||| The IDs of the public subnets"
}

output "public_cidrs" {
  value       = google_compute_subnetwork.public.*.ip_cidr_range
  description = "list(string) ||| The network ranges of the public subnets"
}

output "public_subnet_self_links" {
  value       = google_compute_subnetwork.public.*.self_link
  description = "list(string) ||| The self_link of each public subnet"
}

output "private_subnet_names" {
  value       = google_compute_subnetwork.private.*.name
  description = "list(string) ||| The names of the private subnets"
}

output "private_subnets_ids" {
  value       = google_compute_subnetwork.private.*.id
  description = "list(string) ||| The IDs of the private subnets"
}

output "private_cidrs" {
  value       = google_compute_subnetwork.private.*.ip_cidr_range
  description = "list(string) ||| The network ranges of the private subnets"
}

output "private_subnet_self_links" {
  value       = google_compute_subnetwork.private.*.self_link
  description = "list(string) ||| The self_link of each private subnet"
}

output "connector_subnet_name" {
  value       = google_compute_subnetwork.access_connector.name
  description = "string ||| The name of the private access connector subnet"
}

output "connector_subnet_id" {
  value       = google_compute_subnetwork.access_connector.id
  description = "string ||| The ID of the private access connector subnet"
}

output "connector_subnet_self_link" {
  value       = google_compute_subnetwork.access_connector.self_link
  description = "string ||| The self_link of the private access connector subnet"
}

output "nat_id" {
  value       = google_compute_router_nat.this.id
  description = "string ||| Id of Cloud NAT"
}

output "router_id" {
  value       = google_compute_router.this.id
  description = "string ||| Id of Cloud Router"
}

output "vpc_access_connector" {
  value       = try(google_vpc_access_connector.serverless[0].name, "")
  description = "string ||| The name of the VPC Access Connector that should be used by serverless to access the private subnetworks."
}

output "vpc_access_connector_id" {
  value       = try(google_vpc_access_connector.serverless[0].id, "")
  description = "string ||| The ID of the VPC Access Connector that should be used by serverless to access the private subnetworks."
}

output "private_service_cidrs" {
  value       = [local.private_service_cidr]
  description = "list(string) ||| The CIDR range for accessing google-managed services over Private services access."
}

output "internal_domain_fqdn" {
  value       = local.internal_domain_fqdn
  description = "string ||| The FQDN (fully-qualified domain name) of the DNS zone for internal DNS resolution."
}

output "internal_domain_zone_id" {
  value       = local.internal_domain_zone_id
  description = "string ||| The name of the DNS zone for internal DNS resolution."
}

