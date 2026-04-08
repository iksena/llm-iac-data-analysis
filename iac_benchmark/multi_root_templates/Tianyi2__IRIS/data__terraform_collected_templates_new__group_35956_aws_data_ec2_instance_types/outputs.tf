output "id" {
  description = "AWS Region."
  value       = data.aws_ec2_instance_types.this.id
}

output "instance_types" {
  description = "List of EC2 Instance Types."
  value       = data.aws_ec2_instance_types.this.instance_types
}