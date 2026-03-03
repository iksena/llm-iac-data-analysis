provider "aws" {
  region = "us-west-2"
}

# Create DAX Parameter Group
resource "aws_dax_parameter_group" "custom" {
  name        = "custom-dax-params"
  description = "Custom DAX parameter group for application caching"

  # Parameters are defined as individual blocks
  parameter {
    name  = "query-ttl-millis"
    value = "60000"
  }

  parameter {
    name  = "record-ttl-millis"
    value = "120000"
  }
}

# Output the parameter group name
output "parameter_group_name" {
  value = aws_dax_parameter_group.custom.name
}

# Output the parameter group arn
output "parameter_group_arn" {
  value = aws_dax_parameter_group.custom.arn
}