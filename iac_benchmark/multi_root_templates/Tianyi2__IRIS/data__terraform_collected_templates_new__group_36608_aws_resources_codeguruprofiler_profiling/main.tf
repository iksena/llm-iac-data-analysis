resource "aws_codeguruprofiler_profiling_group" "this" {
  name             = var.name
  compute_platform = var.compute_platform
  region           = var.region
  tags             = var.tags

  agent_orchestration_config {
    profiling_enabled = var.agent_orchestration_config.profiling_enabled
  }
}