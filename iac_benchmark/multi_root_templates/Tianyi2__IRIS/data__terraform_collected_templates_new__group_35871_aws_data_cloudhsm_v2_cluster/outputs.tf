output "cluster_id" {
  description = "ID of Cloud HSM v2 cluster."
  value       = data.aws_cloudhsm_v2_cluster.this.cluster_id
}

output "cluster_state" {
  description = "State of the cluster."
  value       = data.aws_cloudhsm_v2_cluster.this.cluster_state
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_cloudhsm_v2_cluster.this.region
}

output "vpc_id" {
  description = "ID of the VPC that the CloudHSM cluster resides in."
  value       = data.aws_cloudhsm_v2_cluster.this.vpc_id
}

output "security_group_id" {
  description = "ID of the security group associated with the CloudHSM cluster."
  value       = data.aws_cloudhsm_v2_cluster.this.security_group_id
}

output "subnet_ids" {
  description = "IDs of subnets in which cluster operates."
  value       = data.aws_cloudhsm_v2_cluster.this.subnet_ids
}

output "cluster_certificates" {
  description = "The list of cluster certificates."
  value       = data.aws_cloudhsm_v2_cluster.this.cluster_certificates
}

output "cluster_certificate" {
  description = "The cluster certificate issued (signed) by the issuing certificate authority (CA) of the cluster's owner."
  value       = try(data.aws_cloudhsm_v2_cluster.this.cluster_certificates[0].cluster_certificate, null)
}

output "cluster_csr" {
  description = "The certificate signing request (CSR). Available only in UNINITIALIZED state."
  value       = try(data.aws_cloudhsm_v2_cluster.this.cluster_certificates[0].cluster_csr, null)
}

output "aws_hardware_certificate" {
  description = "The HSM hardware certificate issued (signed) by AWS CloudHSM."
  value       = try(data.aws_cloudhsm_v2_cluster.this.cluster_certificates[0].aws_hardware_certificate, null)
}

output "hsm_certificate" {
  description = "The HSM certificate issued (signed) by the HSM hardware."
  value       = try(data.aws_cloudhsm_v2_cluster.this.cluster_certificates[0].hsm_certificate, null)
}

output "manufacturer_hardware_certificate" {
  description = "The HSM hardware certificate issued (signed) by the hardware manufacturer."
  value       = try(data.aws_cloudhsm_v2_cluster.this.cluster_certificates[0].manufacturer_hardware_certificate, null)
}