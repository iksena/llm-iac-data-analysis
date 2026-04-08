resource "aws_cloudsearch_domain_service_access_policy" "this" {
  access_policy = var.access_policy
  domain_name   = var.domain_name
  region        = var.region

  timeouts {
    update = var.timeout_update
    delete = var.timeout_delete
  }
}