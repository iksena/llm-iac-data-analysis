data "aws_docdb_orderable_db_instance" "this" {
  region                     = var.region
  engine                     = var.engine
  engine_version             = var.engine_version
  instance_class             = var.instance_class
  license_model              = var.license_model
  preferred_instance_classes = var.preferred_instance_classes
  vpc                        = var.vpc
}