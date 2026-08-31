variable "region" {
  type        = string
  description = "AWS region the IaC should be deployed into."
  default     = "us-east-1"
}

variable "availability_zone" {
  type        = string
  description = "The AZ that the subnet should be running in."
  default     = "us-east-1a"
}

variable "allowed_http_ip_cidr_blocks_inbound" {
  type        = list(string)
  description = "Networks that are allowed to access the ec2 instance via http (port 80)."
  default     = ["10.0.0.0/16"]
}

variable "allowed_ldap_ip_cidr_blocks_inbound" {
  type        = list(string)
  description = "Networks that are allowed to access the ec2 instance via http (port 389)."
  default     = ["10.0.0.0/16"]
}

variable "allowed_outbound_cidr_blocks" {
  type        = list(string)
  description = "Networks that are allowed tobe accessed by ec2 instance on outbound connections."
  default     = ["0.0.0.0/0"]
}

variable "ec2_instance_type" {
  type        = string
  description = "What instance type ec2 should adopt."
  default     = "t3.micro"
}

variable "user_data_file_path" {
  type        = string
  description = "File path to EC2 user data file"
  default     = "./userdata.sh"
}

variable "tags" {
  type        = map(string)
  description = "Tags associated with resources."
  default     = {}
}
