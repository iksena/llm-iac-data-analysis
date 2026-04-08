data "aws_kendra_faq" "this" {
  region   = var.region
  faq_id   = var.faq_id
  index_id = var.index_id
}