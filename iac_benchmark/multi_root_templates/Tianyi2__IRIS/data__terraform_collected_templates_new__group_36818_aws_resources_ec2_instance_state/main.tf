resource "aws_ec2_instance_state" "this" {
  instance_id = var.instance_id
  state       = var.state
  region      = var.region
  force       = var.force

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}