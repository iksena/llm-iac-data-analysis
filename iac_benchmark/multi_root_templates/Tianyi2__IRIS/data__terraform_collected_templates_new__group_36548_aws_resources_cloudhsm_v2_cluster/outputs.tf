output "cluster_id" {
  description = "The id of the CloudHSM cluster."
  value       = aws_cloudhsm_v2_cluster.this.cluster_id
}

output "cluster_state" {
  description = "The state of the CloudHSM cluster."
  value       = aws_cloudhsm_v2_cluster.this.cluster_state
}

output "vpc_id" {
  description = "The id of the VPC that the CloudHSM cluster resides in."
  value       = aws_cloudhsm_v2_cluster.this.vpc_id
}

output "security_group_id" {
  description = "The ID of the security group associated with the CloudHSM cluster."
  value       = aws_cloudhsm_v2_cluster.this.security_group_id
}

output "cluster_certificates" {
  description = "The list of cluster certificates."
  value       = aws_cloudhsm_v2_cluster.this.cluster_certificates
}

output "cluster_certificate" {
  description = "The cluster certificate issued (signed) by the issuing certificate authority (CA) of the cluster's owner."
  value       = try(aws_cloudhsm_v2_cluster.this.cluster_certificates[0].cluster_certificate, null)
}

output "cluster_csr" {
  description = "The certificate signing request (CSR). Available only in UNINITIALIZED state after an HSM instance is added to the cluster."
  value       = try(aws_cloudhsm_v2_cluster.this.cluster_certificates[0].cluster_csr, null)
}

output "aws_hardware_certificate" {
  description = "The HSM hardware certificate issued (signed) by AWS CloudHSM."
  value       = try(aws_cloudhsm_v2_cluster.this.cluster_certificates[0].aws_hardware_certificate, null)
}

output "hsm_certificate" {
  description = "The HSM certificate issued (signed) by the HSM hardware."
  value       = try(aws_cloudhsm_v2_cluster.this.cluster_certificates[0].hsm_certificate, null)
}

output "manufacturer_hardware_certificate" {
  description = "The HSM hardware certificate issued (signed) by the hardware manufacturer."
  value       = try(aws_cloudhsm_v2_cluster.this.cluster_certificates[0].manufacturer_hardware_certificate, null)
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_cloudhsm_v2_cluster.this.tags_all
}