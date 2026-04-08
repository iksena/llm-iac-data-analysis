data "aws_connect_hours_of_operation" "this" {
  region                = var.region
  instance_id           = var.instance_id
  hours_of_operation_id = var.hours_of_operation_id
  name                  = var.name
}