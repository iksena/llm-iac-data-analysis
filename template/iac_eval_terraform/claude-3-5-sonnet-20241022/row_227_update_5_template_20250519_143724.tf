provider "aws" {
  region = "us-west-2"
}

# Create DAX Parameter Group
resource "aws_dax_parameter_group" "example" {
  name        = "dax-param-group-example"
  description = "DAX parameter group for example application"

  parameters {
    name  = "query-ttl-millis"
    value = "100000"
  }

  parameters {
    name  = "record-ttl-millis"
    value = "100000"
  }
}

# Output the parameter group name
output "parameter_group_name" {
  value = aws_dax_parameter_group.example.name
}