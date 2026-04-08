data "aws_ssm_parameters_by_path" "this" {
  region          = var.region
  path            = var.path
  with_decryption = var.with_decryption
  recursive       = var.recursive
}