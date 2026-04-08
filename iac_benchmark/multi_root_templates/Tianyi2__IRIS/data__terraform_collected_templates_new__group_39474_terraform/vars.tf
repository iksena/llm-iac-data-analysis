variable region {
  type = string
}

variable profile {
  type = string
}

variable vpc_id {
  type = string
}

variable sg_id {
  type = string
}

#data "aws_security_group" "uas_dev" {
#  vpc_id = var.vpc_id
#  id = var.sg_id
#}

variable role {
  type = string
}

variable subnet_id {
  type = string
}

variable subnet_ids {
  type = list
}

variable ami {
  type = string
}

#variable key_name {
#  type = string
#}

variable rest_api_stage {
  type = string
}

variable rest_api_name {
  type = string
}

#variable rest_api_id {
#  type = string
#}

variable parent_id {
  type = string
}

variable path_part {
  type = string
}

variable common_tags {
  type = map
}
