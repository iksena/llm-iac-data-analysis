resource "aws_opensearch_package_association" "this" {
  region      = var.region
  package_id  = var.package_id
  domain_name = var.domain_name

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}