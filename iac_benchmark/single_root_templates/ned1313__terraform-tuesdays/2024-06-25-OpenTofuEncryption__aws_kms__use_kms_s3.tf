# ── main.tf ────────────────────────────────────
resource "local_file" "main" {
  content  = "Change contents!"
  filename = "${path.module}/testplan2.txt"
}

output "test" {
  value = local_file.main.filename
}

# ── terraform.tf ────────────────────────────────────
terraform {
  backend "s3" {
    region  = "us-west-2"
    bucket  = "tofu-test-encrypted70785"
    key     = "terraform.tfstate"
    encrypt = "true"

    dynamodb_table = "tofu-test-encrypted70785-lock"
  }
}