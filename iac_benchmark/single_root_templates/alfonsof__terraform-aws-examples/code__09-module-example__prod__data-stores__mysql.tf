# ── main.tf ────────────────────────────────────
# Configure the AWS provider
provider "aws" {
  region = "eu-west-1"
}

# Create a DB instance
resource "aws_db_instance" "example" {
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "example_database_prod"
  username            = "admin"
  password            = "${var.db_password}"
  skip_final_snapshot = true
}


# ── outputs.tf ────────────────────────────────────
# Output variable: DB instance address
output "address" {
  value = "${aws_db_instance.example.address}"
}

# Output variable: DB instance port
output "port" {
  value = "${aws_db_instance.example.port}"
}


# ── backend.tf ────────────────────────────────────
# Define Terraform backend using a S3 bucket for storing the Terraform state
terraform {
  backend "s3" {
    bucket = "terraform-state-my-bucket"
    key    = "module-example/prod/data-stores/mysql/terraform.tfstate"
    region = "eu-west-1"
  }
}


# ── vars.tf ────────────────────────────────────
# Input variable: DB password
variable "db_password" {
  description = "The password for the database"
}
