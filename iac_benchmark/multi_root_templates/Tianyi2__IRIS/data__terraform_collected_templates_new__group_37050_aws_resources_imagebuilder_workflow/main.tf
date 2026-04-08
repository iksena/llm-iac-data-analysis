resource "aws_imagebuilder_workflow" "this" {
  name    = var.name
  type    = var.type
  version = var.workflow_version

  region             = var.region
  change_description = var.change_description
  data               = var.data
  description        = var.description
  kms_key_id         = var.kms_key_id
  tags               = var.tags
  uri                = var.uri
}