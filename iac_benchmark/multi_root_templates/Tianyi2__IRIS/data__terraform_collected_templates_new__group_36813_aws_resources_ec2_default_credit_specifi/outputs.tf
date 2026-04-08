
output "region" {
  description = "The region of the EC2 Default Credit Specification."
  value       = aws_ec2_default_credit_specification.this.region
}

output "cpu_credits" {
  description = "The CPU credits setting for the instance family."
  value       = aws_ec2_default_credit_specification.this.cpu_credits
}

output "instance_family" {
  description = "The instance family."
  value       = aws_ec2_default_credit_specification.this.instance_family
}