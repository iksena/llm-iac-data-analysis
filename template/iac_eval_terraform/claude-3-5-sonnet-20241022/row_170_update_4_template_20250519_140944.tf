provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-12345678", "subnet-87654321"]  # Replace with actual subnet IDs
  description = "List of subnet IDs for DAX subnet group"
}

# Create DAX subnet group
resource "aws_dax_subnet_group" "dax_subnet_group" {
  name       = "my-dax-subnet-group"
  subnet_ids = var.subnet_ids
}