provider "aws" {
  region = "us-west-2"
}

resource "aws_dax_parameter_group" "custom_dax_parameter_group" {
  name        = "custom-dax-parameter-group"
  description = "Custom DAX parameter group for performance tuning"

  parameter {
    name  = "query-ttl-millis"
    value = "60000"
  }

  parameter {
    name  = "record-ttl-millis"
    value = "300000"
  }

  parameter {
    name  = "max-cache-memory-per-node-mb"
    value = "2048"
  }
}