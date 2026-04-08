resource "aws_opensearch_domain_policy" "this" {
  domain_name     = var.domain_name
  access_policies = var.access_policies

  timeouts {
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}