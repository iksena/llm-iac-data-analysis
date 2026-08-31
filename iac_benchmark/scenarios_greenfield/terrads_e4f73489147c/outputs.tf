output "nginx_test" {
  value = "curl http://${aws_ecs_service.app.name}.${aws_service_discovery_private_dns_namespace.app.name}"
}
