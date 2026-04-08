data "aws_kendra_thesaurus" "this" {
  region       = var.region
  index_id     = var.index_id
  thesaurus_id = var.thesaurus_id
}