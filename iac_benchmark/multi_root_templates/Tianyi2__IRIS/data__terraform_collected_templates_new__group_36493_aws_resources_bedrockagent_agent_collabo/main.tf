resource "aws_bedrockagent_agent_collaborator" "this" {
  agent_id                   = var.agent_id
  collaboration_instruction  = var.collaboration_instruction
  collaborator_name          = var.collaborator_name
  region                     = var.region
  prepare_agent              = var.prepare_agent
  relay_conversation_history = var.relay_conversation_history

  agent_descriptor {
    alias_arn = var.agent_descriptor_alias_arn
  }

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}