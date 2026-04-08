data "aws_connect_vocabulary" "this" {
  region        = var.region
  instance_id   = var.instance_id
  name          = var.name
  vocabulary_id = var.vocabulary_id
}