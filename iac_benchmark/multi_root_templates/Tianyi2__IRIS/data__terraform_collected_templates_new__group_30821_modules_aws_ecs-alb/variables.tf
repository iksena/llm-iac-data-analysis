variable "name" {
  type = string
}

variable "domain" {
  type = string
  default = ""
}

variable "subdomain" {
  type = string
  default = ""
}


variable "tcp_ingress" {
  type = map(list(string))
  default = {
    "80" = [ "0.0.0.0/0" ]
    "443" = [ "0.0.0.0/0" ]
  }
}

variable "allow_additional_sg" {
  type = map(object({
    security_groups = list(string)
    from_port       = string
    to_port         = string
    protocol        = string
  }))
  default = {}
}

variable "ecs_sg" {
  default = []
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "target_group_name" {
  type = string
}

variable "health_check_path" {
  type = string
}

variable "volume_mapping" {
  type = map(string)
  default = {}
}

variable "health_check_port" {
  type = string
  default = null
}

variable "target_group_port" {
  type = string
  default = "80"
}