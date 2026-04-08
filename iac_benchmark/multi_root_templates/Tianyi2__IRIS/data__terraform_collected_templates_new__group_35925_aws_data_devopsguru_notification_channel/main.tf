data "aws_devopsguru_notification_channel" "this" {
  id     = var.id
  region = var.region
}