data "aws_ec2_capacity_block_offering" "this" {
  region                  = var.region
  capacity_duration_hours = var.capacity_duration_hours
  end_date_range          = var.end_date_range
  instance_count          = var.instance_count
  instance_type           = var.instance_type
  start_date_range        = var.start_date_range
}