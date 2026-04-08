data "aws_fis_experiment_templates" "this" {
  region = var.region
  tags   = var.tags
}