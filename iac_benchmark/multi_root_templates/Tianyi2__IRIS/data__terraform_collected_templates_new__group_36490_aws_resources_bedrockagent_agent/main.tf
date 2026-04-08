resource "aws_bedrockagent_agent" "this" {
  agent_name              = var.agent_name
  agent_resource_role_arn = var.agent_resource_role_arn
  foundation_model        = var.foundation_model

  region                      = var.region
  agent_collaboration         = var.agent_collaboration
  customer_encryption_key_arn = var.customer_encryption_key_arn
  description                 = var.description
  idle_session_ttl_in_seconds = var.idle_session_ttl_in_seconds
  instruction                 = var.instruction
  prepare_agent               = var.prepare_agent
  skip_resource_in_use_check  = var.skip_resource_in_use_check
  tags                        = var.tags

  dynamic "guardrail_configuration" {
    for_each = var.guardrail_configuration != null ? [var.guardrail_configuration] : []
    content {
      guardrail_identifier = guardrail_configuration.value.guardrail_identifier
      guardrail_version    = guardrail_configuration.value.guardrail_version
    }
  }

  dynamic "memory_configuration" {
    for_each = var.memory_configuration != null ? [var.memory_configuration] : []
    content {
      enabled_memory_types = memory_configuration.value.enabled_memory_types
      storage_days         = memory_configuration.value.storage_days
    }
  }

  dynamic "prompt_override_configuration" {
    for_each = var.prompt_override_configuration != null ? [var.prompt_override_configuration] : []
    content {
      override_lambda = prompt_override_configuration.value.override_lambda

      dynamic "prompt_configurations" {
        for_each = prompt_override_configuration.value.prompt_configurations
        content {
          base_prompt_template = prompt_configurations.value.base_prompt_template
          parser_mode          = prompt_configurations.value.parser_mode
          prompt_creation_mode = prompt_configurations.value.prompt_creation_mode
          prompt_state         = prompt_configurations.value.prompt_state
          prompt_type          = prompt_configurations.value.prompt_type

          dynamic "inference_configuration" {
            for_each = [prompt_configurations.value.inference_configuration]
            content {
              max_length     = inference_configuration.value.max_length
              stop_sequences = inference_configuration.value.stop_sequences
              temperature    = inference_configuration.value.temperature
              top_k          = inference_configuration.value.top_k
              top_p          = inference_configuration.value.top_p
            }
          }
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}