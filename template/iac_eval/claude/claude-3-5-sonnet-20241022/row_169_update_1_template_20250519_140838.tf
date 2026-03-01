provider "aws" {
  region = "us-west-2"
}

# Create DAX Parameter Group
resource "aws_dax_parameter_group" "custom" {
  name        = "custom-dax-params"
  description = "Custom DAX parameter group for application caching"
  
  # Parameters can be adjusted based on your needs
  parameters {
    name  = "query-ttl-millis"
    value = "60000"  # 60 seconds
  }

  parameters {
    name  = "record-ttl-millis"
    value = "120000"  # 120 seconds
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