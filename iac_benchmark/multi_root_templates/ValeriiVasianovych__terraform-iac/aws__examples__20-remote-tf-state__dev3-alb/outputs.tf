output "ec2_remote_state_outputs" {
  value = data.terraform_remote_state.ec2.outputs
}

output "nlb_dns_name" {
  value = aws_lb.webservers_nlb.dns_name
}