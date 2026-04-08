resource "aws_codepipeline" "this" {
  name          = var.name
  pipeline_type = var.pipeline_type
  role_arn      = var.role_arn
  region        = var.region

  execution_mode = var.execution_mode

  dynamic "artifact_store" {
    for_each = var.artifact_store
    content {
      location = artifact_store.value.location
      type     = artifact_store.value.type
      region   = artifact_store.value.region

      dynamic "encryption_key" {
        for_each = artifact_store.value.encryption_key != null ? [artifact_store.value.encryption_key] : []
        content {
          id   = encryption_key.value.id
          type = encryption_key.value.type
        }
      }
    }
  }

  dynamic "stage" {
    for_each = var.stage
    content {
      name = stage.value.name

      dynamic "action" {
        for_each = stage.value.action
        content {
          category         = action.value.category
          owner            = action.value.owner
          name             = action.value.name
          provider         = action.value.provider
          version          = action.value.version
          configuration    = action.value.configuration
          input_artifacts  = action.value.input_artifacts
          output_artifacts = action.value.output_artifacts
          role_arn         = action.value.role_arn
          run_order        = action.value.run_order
          region           = action.value.region
          namespace        = action.value.namespace
        }
      }

      dynamic "before_entry" {
        for_each = stage.value.before_entry != null ? [stage.value.before_entry] : []
        content {
          dynamic "condition" {
            for_each = before_entry.value.condition
            content {
              result = condition.value.result

              dynamic "rule" {
                for_each = condition.value.rule != null ? condition.value.rule : []
                content {
                  name               = rule.value.name
                  commands           = rule.value.commands
                  configuration      = rule.value.configuration
                  input_artifacts    = rule.value.input_artifacts
                  region             = rule.value.region
                  role_arn           = rule.value.role_arn
                  timeout_in_minutes = rule.value.timeout_in_minutes

                  rule_type_id {
                    category = rule.value.rule_type_id.category
                    provider = rule.value.rule_type_id.provider
                    owner    = rule.value.rule_type_id.owner
                    version  = rule.value.rule_type_id.version
                  }
                }
              }
            }
          }
        }
      }

      dynamic "on_success" {
        for_each = stage.value.on_success != null ? [stage.value.on_success] : []
        content {
          dynamic "condition" {
            for_each = on_success.value.condition
            content {
              result = condition.value.result

              dynamic "rule" {
                for_each = condition.value.rule != null ? condition.value.rule : []
                content {
                  name               = rule.value.name
                  commands           = rule.value.commands
                  configuration      = rule.value.configuration
                  input_artifacts    = rule.value.input_artifacts
                  region             = rule.value.region
                  role_arn           = rule.value.role_arn
                  timeout_in_minutes = rule.value.timeout_in_minutes

                  rule_type_id {
                    category = rule.value.rule_type_id.category
                    provider = rule.value.rule_type_id.provider
                    owner    = rule.value.rule_type_id.owner
                    version  = rule.value.rule_type_id.version
                  }
                }
              }
            }
          }
        }
      }

      dynamic "on_failure" {
        for_each = stage.value.on_failure != null ? [stage.value.on_failure] : []
        content {
          result = on_failure.value.result

          dynamic "condition" {
            for_each = on_failure.value.condition != null ? [on_failure.value.condition] : []
            content {
              result = condition.value.result

              dynamic "rule" {
                for_each = condition.value.rule != null ? condition.value.rule : []
                content {
                  name               = rule.value.name
                  commands           = rule.value.commands
                  configuration      = rule.value.configuration
                  input_artifacts    = rule.value.input_artifacts
                  region             = rule.value.region
                  role_arn           = rule.value.role_arn
                  timeout_in_minutes = rule.value.timeout_in_minutes

                  rule_type_id {
                    category = rule.value.rule_type_id.category
                    provider = rule.value.rule_type_id.provider
                    owner    = rule.value.rule_type_id.owner
                    version  = rule.value.rule_type_id.version
                  }
                }
              }
            }
          }

          dynamic "retry_configuration" {
            for_each = on_failure.value.retry_configuration != null ? [on_failure.value.retry_configuration] : []
            content {
              retry_mode = retry_configuration.value.retry_mode
            }
          }
        }
      }
    }
  }

  dynamic "trigger" {
    for_each = var.trigger
    content {
      provider_type = trigger.value.provider_type

      git_configuration {
        source_action_name = trigger.value.git_configuration.source_action_name

        dynamic "pull_request" {
          for_each = trigger.value.git_configuration.pull_request != null ? [trigger.value.git_configuration.pull_request] : []
          content {
            events = pull_request.value.events

            dynamic "branches" {
              for_each = pull_request.value.branches != null ? [pull_request.value.branches] : []
              content {
                includes = branches.value.includes
                excludes = branches.value.excludes
              }
            }

            dynamic "file_paths" {
              for_each = pull_request.value.file_paths != null ? [pull_request.value.file_paths] : []
              content {
                includes = file_paths.value.includes
                excludes = file_paths.value.excludes
              }
            }
          }
        }

        dynamic "push" {
          for_each = trigger.value.git_configuration.push != null ? [trigger.value.git_configuration.push] : []
          content {
            dynamic "branches" {
              for_each = push.value.branches != null ? [push.value.branches] : []
              content {
                includes = branches.value.includes
                excludes = branches.value.excludes
              }
            }

            dynamic "file_paths" {
              for_each = push.value.file_paths != null ? [push.value.file_paths] : []
              content {
                includes = file_paths.value.includes
                excludes = file_paths.value.excludes
              }
            }

            dynamic "tags" {
              for_each = push.value.tags != null ? [push.value.tags] : []
              content {
                includes = tags.value.includes
                excludes = tags.value.excludes
              }
            }
          }
        }
      }
    }
  }

  dynamic "variable" {
    for_each = var.variable
    content {
      name          = variable.value.name
      default_value = variable.value.default_value
      description   = variable.value.description
    }
  }

  tags = var.tags
}