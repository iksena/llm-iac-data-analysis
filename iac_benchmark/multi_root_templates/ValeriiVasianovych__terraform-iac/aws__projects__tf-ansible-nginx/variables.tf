variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Owner       = "Valerii Vasianovych"
    Environment = "Development"
  }
}

locals {
  vpc_id           = "vpc-0f47deecc163757a6"
  subnet_id        = "subnet-001cbe6a01612ea6c"
  ssh_user         = "ubuntu"
  key_name         = "ServersKey"
  private_key_path = "~/ssh_key_pairs/aws/ServersKey.pem"
}