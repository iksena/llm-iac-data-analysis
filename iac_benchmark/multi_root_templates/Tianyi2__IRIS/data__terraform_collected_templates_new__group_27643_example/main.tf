terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "3.2.3"
    }
  }
}

resource "null_resource" "cluster" {
  count = 30
  triggers = {
    foo = "bar"
  }

  provisioner "local-exec" {
    command = "sleep ${count.index % 5 + 1}"
  }
}

output "output_string" {
   value = null_resource.cluster[0].id
}

output "output_bool" {
    value = true
}

output "output_num" {
    value = 123
}
