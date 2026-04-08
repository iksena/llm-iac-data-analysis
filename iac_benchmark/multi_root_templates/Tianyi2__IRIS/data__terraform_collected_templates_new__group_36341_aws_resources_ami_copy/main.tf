resource "aws_ami_copy" "this" {
  region                  = var.region
  name                    = var.name
  source_ami_id           = var.source_ami_id
  source_ami_region       = var.source_ami_region
  destination_outpost_arn = var.destination_outpost_arn
  encrypted               = var.encrypted
  kms_key_id              = var.kms_key_id
  tags                    = var.tags

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}