# ── main.tf ────────────────────────────────────
# Configure the AWS provider
provider "aws" {
  region = "eu-west-1"
}

# Use Module
module "webserver_cluster" {
  source = "git::git@github.com:alfonsof/terraform-aws-repo-examples.git//modules/services/webserver-cluster?ref=v0.0.2"
  
  cluster_name           = "werservers-stage"
  db_remote_state_bucket = "${var.db_remote_state_bucket}"
  db_remote_state_key    = "${var.db_remote_state_key}"
  
  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}

# Create a Security Group Rule
resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = "${module.webserver_cluster.elb_security_group_id}"

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
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
    key    = "multi-repo-example/live/stage/services/webserver-cluster/terraform.tfstate"
    region = "eu-west-1"
  }
}


# ── vars.tf ────────────────────────────────────
# Input variable: DB remote state bucket name
variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  default     =  "terraform-state-my-bucket"
}

# Input variable: DB remote state bucket key
variable "db_remote_state_key" {
  description = "The path for database's remote state in S3"
  default     = "multi-repo-example/live/stage/data-stores/mysql/terraform.tfstate"
}
