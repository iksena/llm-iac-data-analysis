data "aws_ssmcontacts_plan" "this" {
  contact_id = var.contact_id
  region     = var.region
}