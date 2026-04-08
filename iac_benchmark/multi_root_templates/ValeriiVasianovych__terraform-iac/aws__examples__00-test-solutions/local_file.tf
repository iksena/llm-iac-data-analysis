resource "local_file" "foo_file" {
  content  = "The environment of this terraform is: ${var.environment}"
  filename = "${path.module}/local_files/foo_file.txt"
}

variable "files" {
  default = {
    "dev.txt"     = "Development Environment"
    "prod.txt"    = "Production Environment"
    "staging.txt" = "Staging Environment"
  }
}

resource "local_file" "multiple_files" {
  for_each = var.files

  content  = each.value
  filename = "${path.module}/local_files/${each.key}"
}