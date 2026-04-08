resource "aws_ec2_network_insights_analysis" "this" {
  network_insights_path_id = var.network_insights_path_id
  region                   = var.region
  filter_in_arns           = var.filter_in_arns
  wait_for_completion      = var.wait_for_completion
  tags                     = var.tags
}