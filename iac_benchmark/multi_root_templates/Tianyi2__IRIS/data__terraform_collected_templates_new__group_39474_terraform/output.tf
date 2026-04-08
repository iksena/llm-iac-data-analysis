#output "debugger_host_id" {
#  value = aws_instance.unity_dapa_debugger_host.id
#}
#output "debugger_host_private_dns" {
#  value = aws_instance.unity_dapa_debugger_host.private_dns
#}
#output "debugger_host_public_dns" {
#  value = aws_instance.unity_dapa_debugger_host.public_dns
#}
#output "debugger_host_public_ip" {
#  value = aws_instance.unity_dapa_debugger_host.public_ip
#}

output "instance_id" {
  value = aws_instance.unity_dapa_instance.id
}
output "instance_private_dns" {
  value = aws_instance.unity_dapa_instance.private_dns
}
output "instance_public_dns" {
  value = aws_instance.unity_dapa_instance.public_dns
}

output "instance_tags_all" {
  value = aws_instance.unity_dapa_instance.tags_all
}

output "load_balancer_arn" {
  value = aws_lb.unity-dapa-lb-tf.arn
}

output "load_balancer_dns_name" {
  value = aws_lb.unity-dapa-lb-tf.dns_name
}

output "api_gateway_invoke_url" {
  value = aws_api_gateway_deployment.unit_rest_api_deployment.invoke_url
}

#output "api_gateway_vpc_link" {
#  value = data.aws_api_gateway_vpc_link.unity_dapa_vpc_link.id
#}

