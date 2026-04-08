variable "resource_name" {}
variable "instance_name" {
  default = "my-instance"
}
variable "object" {
  type = object({
    name = optional(string)
  })
}

moved {
  from = aws_instance.a
  to   = aws_instance.b
}

import {
  id = "i-123545"
  to = aws_instance.b
}

removed {
  from = aws_instance.c
  lifecycle {
    destroy = false
  }
}

check "test" {
  assert {
    condition     = aws_instance.c.id == "i-12346578"
    error_message = "missing instance id"
  }
}
