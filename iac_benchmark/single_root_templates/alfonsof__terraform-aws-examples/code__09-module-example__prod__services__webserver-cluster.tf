# ── main.tf ────────────────────────────────────
# Configure the AWS provider
provider "aws" {
  region = "eu-west-1"
}

# Use Module
module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  
  cluster_name           = "werservers-prod"
  db_remote_state_bucket = "${var.db_remote_state_bucket}"
  db_remote_state_key    = "${var.db_remote_state_key}"

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 10
}

# Create an Autoscaling Schedule
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 10
  recurrence            = "0 9 * * *"
  
  autoscaling_group_name = "${module.webserver_cluster.asg_name}"
}

# Create an Autoscaling Schedule
resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"

  autoscaling_group_name = "${module.webserver_cluster.asg_name}"
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
    key    = "module-example/prod/services/webserver-cluster/terraform.tfstate"
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
  default     = "module-example/prod/data-stores/mysql/terraform.tfstate"
}
