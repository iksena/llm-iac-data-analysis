provider "aws" {
  region = "us-west-2"
}

# Create DAX Parameter Group
resource "aws_dax_parameter_group" "example" {
  name        = "custom-dax-params"
  description = "Custom DAX parameter group for application caching"
}

# Output the parameter group name
output "parameter_group_name" {
  value = aws_dax_parameter_group.example.name
}

# Output the parameter group arn
output "parameter_group_arn" {
  value = aws_dax_parameter_group.example.arn
}