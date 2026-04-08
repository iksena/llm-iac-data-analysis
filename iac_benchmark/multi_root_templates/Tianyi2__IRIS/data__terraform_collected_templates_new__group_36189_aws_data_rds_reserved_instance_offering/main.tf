data "aws_rds_reserved_instance_offering" "this" {
  region              = var.region
  db_instance_class   = var.db_instance_class
  duration            = var.duration
  multi_az            = var.multi_az
  offering_type       = var.offering_type
  product_description = var.product_description
}