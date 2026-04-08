resource "aws_ssmcontacts_contact" "this" {
  alias        = var.alias
  type         = var.type
  region       = var.region
  display_name = var.display_name
  tags         = var.tags
}