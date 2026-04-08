# Outputs
# output "created_instance_type" {
#   value = aws_instance.example_ec2.instance_type
# }

# output "created_instance_az" {
#   value = aws_instance.example_ec2.availability_zone
# }

output "file_content" {
  value = local.file_content
}

output "multiply" {
  value = 2 * 7
}

output "greater_than" {
  value = 5 > 4
}

# output "hello_world" {
#   value = "${var.1_hello_world}"
# }