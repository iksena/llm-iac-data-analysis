variable "region" {
  description = "AWS Region"
  default     = "us-west-2"
}

variable "environment" {
  description = "Deployment environment name."
  default     = "interview"
}

variable "vpc_name" { default = "interview-vpc" }
variable "env_prefix" { default = "interview-vpc" }
variable "vpc_domain" { default = "interview.resonance.com" }
variable "vpc_cidr" { default = "10.1.0.0/16" }
# TODO(Garrett): use https://www.terraform.io/docs/language/functions/cidrsubnets.html
variable "vpc_private_cidr" { default = "10.1.0.0/20" }
variable "private_subnets" {
  default = {
    "interview_private_az_a" = {
      "cidr" = "10.1.0.0/24",
      "az"   = "us-west-2a"
    }
  }
}

variable "vpc_public_cidr" { default = "10.1.16.0/20" }
variable "public_subnets" {
  default = {
    "interview_public_az_a" = {
      "cidr" = "10.1.16.0/24",
      "az"   = "us-west-2a"
    }
  }
}


# RDS DB Variables
variable "db_name" { default = "interviewdefault" }
variable "db_identifier" { default = "interview-default" }
# Normally I would encrypt a new pwd using a KMS key after
# initiation, and set the encrypted hash as a variable and
# re-apply the terraform. I don't have enough time for this.
variable "db_pwd" { default = "TempPassword00!!" }
variable "db_storage_size" { default = 100 }
variable "db_max_allocated_storage" { default = 1000 }
variable "db_instance_class" { default = "db.m5.large" }
variable "db_engine_version" { default = "11.10" }
variable "db_publicly_accesible" { default = false }
variable "db_skip_final_snapshot" { default = true }
variable "db_backup_retention_period" { default = 7 }

# EC2 variables.  For the sake of time, I'm using the same
# variables for both UI and API instances
variable "instance_type" { default = "t2.micro" }
variable "ami" { default = "ami-a0cfeed8" } # us-west-2
variable "volume_size" { default = 500 }
variable "volume_type" { default = "gp2" }

