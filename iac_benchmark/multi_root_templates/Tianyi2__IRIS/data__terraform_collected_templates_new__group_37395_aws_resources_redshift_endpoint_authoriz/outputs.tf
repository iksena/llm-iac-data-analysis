output "region" {
  description = "Region where this resource will be managed."
  value       = aws_redshift_endpoint_authorization.this.region
}

output "account" {
  description = "The Amazon Web Services account ID to grant access to."
  value       = aws_redshift_endpoint_authorization.this.account
}

output "cluster_identifier" {
  description = "The cluster identifier of the cluster to grant access to."
  value       = aws_redshift_endpoint_authorization.this.cluster_identifier
}

output "force_delete" {
  description = "Indicates whether to force the revoke action."
  value       = aws_redshift_endpoint_authorization.this.force_delete
}

output "vpc_ids" {
  description = "The virtual private cloud (VPC) identifiers to grant access to."
  value       = aws_redshift_endpoint_authorization.this.vpc_ids
}

output "allowed_all_vpcs" {
  description = "Indicates whether all VPCs in the grantee account are allowed access to the cluster."
  value       = aws_redshift_endpoint_authorization.this.allowed_all_vpcs
}

output "id" {
  description = "The identifier of the Redshift Endpoint Authorization, account, and cluster_identifier separated by a colon (:)."
  value       = aws_redshift_endpoint_authorization.this.id
}

output "endpoint_count" {
  description = "The number of Redshift-managed VPC endpoints created for the authorization."
  value       = aws_redshift_endpoint_authorization.this.endpoint_count
}

output "grantee" {
  description = "The Amazon Web Services account ID of the grantee of the cluster."
  value       = aws_redshift_endpoint_authorization.this.grantee
}

output "grantor" {
  description = "The Amazon Web Services account ID of the cluster owner."
  value       = aws_redshift_endpoint_authorization.this.grantor
}