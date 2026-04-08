data "aws_bedrockagent_agent_versions" "this" {
  region   = var.region
  agent_id = var.agent_id
}