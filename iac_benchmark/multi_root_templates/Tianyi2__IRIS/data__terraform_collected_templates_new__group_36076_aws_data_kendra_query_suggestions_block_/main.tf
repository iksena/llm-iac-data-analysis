data "aws_kendra_query_suggestions_block_list" "this" {
  region                          = var.region
  index_id                        = var.index_id
  query_suggestions_block_list_id = var.query_suggestions_block_list_id
}