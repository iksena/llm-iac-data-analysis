output "availability_zone" {
  description = "Name of the Availability Zone the HSM instance is located in."
  value       = aws_cloudhsm_v2_hsm.this.availability_zone
}

output "cluster_id" {
  description = "ID of Cloud HSM v2 cluster."
  value       = aws_cloudhsm_v2_hsm.this.cluster_id
}

output "hsm_eni_id" {
  description = "The id of the ENI interface allocated for HSM module."
  value       = aws_cloudhsm_v2_hsm.this.hsm_eni_id
}

output "hsm_id" {
  description = "The id of the HSM module."
  value       = aws_cloudhsm_v2_hsm.this.hsm_id
}

output "hsm_state" {
  description = "The state of the HSM module."
  value       = aws_cloudhsm_v2_hsm.this.hsm_state
}

output "ip_address" {
  description = "The IP address of the HSM Module."
  value       = aws_cloudhsm_v2_hsm.this.ip_address
}

output "subnet_id" {
  description = "The ID of subnet in which HSM is located"
  value       = aws_cloudhsm_v2_hsm.this.subnet_id
}