data "aws_ec2_serial_console_access" "this" {
  region = var.region

  timeouts {
    read = var.timeout_read
  }
}