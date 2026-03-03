provider "aws" {
  region = "us-west-2"
}

resource "aws_dax_parameter_group" "example" {
  name        = "example-dax-parameter-group"
  description = "An example DAX parameter group"

  parameters = {
    "query-ttl-millis" = "60000"
    "record-ttl-millis" = "60000"
  }
}