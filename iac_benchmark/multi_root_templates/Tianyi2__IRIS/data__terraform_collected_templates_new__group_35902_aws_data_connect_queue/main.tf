data "aws_connect_queue" "this" {
  instance_id = var.instance_id
  queue_id    = var.queue_id
  name        = var.name
  region      = var.region
}