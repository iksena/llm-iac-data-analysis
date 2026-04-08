resource "aws_bedrockagent_agent_alias" "this" {
  agent_alias_name = var.agent_alias_name
  agent_id         = var.agent_id
  region           = var.region
  description      = var.description
  tags             = var.tags

  dynamic "routing_configuration" {
    for_each = var.routing_configuration != null ? [var.routing_configuration] : []
    content {
      agent_version          = routing_configuration.value.agent_version
      provisioned_throughput = routing_configuration.value.provisioned_throughput
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}