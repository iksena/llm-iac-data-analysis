resource "aws_bedrockagent_agent_knowledge_base_association" "this" {
  agent_id             = var.agent_id
  description          = var.description
  knowledge_base_id    = var.knowledge_base_id
  knowledge_base_state = var.knowledge_base_state
  region               = var.region
  agent_version        = var.agent_version

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
  }
}