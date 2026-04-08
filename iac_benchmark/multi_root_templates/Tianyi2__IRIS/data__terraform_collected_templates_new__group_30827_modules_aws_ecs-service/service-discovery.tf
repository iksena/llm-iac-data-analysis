resource "aws_service_discovery_private_dns_namespace" "service" {
  count = var.enable_service_discovery ? 1 : 0

  name = var.service_dns_name
  description = var.service_dns_description != "" ? var.service_dns_description : "Domain ${var.service_dns_name} for the service ${var.service_name}"
  vpc = var.vpc_id
}

resource "aws_service_discovery_service" "service" {
  count = var.enable_service_discovery ? 1 : 0
  
  name = var.service_name
  dns_config {
    namespace_id = "${aws_service_discovery_private_dns_namespace.service[0].id}"
    routing_policy = "MULTIVALUE"
    dns_records {
      ttl = 10
      type = "A"
    } 
  }

  health_check_custom_config {
    failure_threshold = 5
  }

}

