# ── main.tf ────────────────────────────────────
# Configure the AWS provider
provider "aws" {
  region = "eu-west-1"
}

# Use Module
module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"
  
  cluster_name           = "werservers-prod"
  db_remote_state_bucket = "${var.db_remote_state_bucket}"
  db_remote_state_key    = "${var.db_remote_state_key}"

  instance_type        = "t2.micro"
  min_size             = 2
  max_size             = 10
  enable_autoscaling   = true
  enable_new_user_data = false
}


# ── outputs.tf ────────────────────────────────────
# Output variable: DNS Name of ELB
output "elb_dns_name" {
  value = "${module.webserver_cluster.elb_dns_name}"
}


# ── backend.tf ────────────────────────────────────
# Define Terraform backend using a S3 bucket for storing the Terraform state
terraform {
  backend "s3" {
    bucket = "terraform-state-my-bucket"
    key    = "if-statements-example/prod/services/webserver-cluster/terraform.tfstate"
    region = "eu-west-1"
  }
}


# ── vars.tf ────────────────────────────────────
# Input variable: DB remote state bucket name
variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  default     =  "terraform-state-afb"
}

# Input variable: DB remote state bucket key
variable "db_remote_state_key" {
  description = "The path for database's remote state in S3"
  default     = "if-statements-example/prod/data-stores/mysql/terraform.tfstate"
}
