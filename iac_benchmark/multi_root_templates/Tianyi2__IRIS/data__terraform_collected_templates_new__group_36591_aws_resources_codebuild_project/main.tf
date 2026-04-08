resource "aws_codebuild_project" "this" {
  name                   = var.name
  description            = var.description
  build_timeout          = var.build_timeout
  queued_timeout         = var.queued_timeout
  service_role           = var.service_role
  badge_enabled          = var.badge_enabled
  concurrent_build_limit = var.concurrent_build_limit
  encryption_key         = var.encryption_key
  project_visibility     = var.project_visibility
  resource_access_role   = var.resource_access_role
  source_version         = var.source_version
  tags                   = var.tags

  artifacts {
    artifact_identifier    = var.artifacts.artifact_identifier
    bucket_owner_access    = var.artifacts.bucket_owner_access
    encryption_disabled    = var.artifacts.encryption_disabled
    location               = var.artifacts.location
    name                   = var.artifacts.name
    namespace_type         = var.artifacts.namespace_type
    override_artifact_name = var.artifacts.override_artifact_name
    packaging              = var.artifacts.packaging
    path                   = var.artifacts.path
    type                   = var.artifacts.type
  }

  dynamic "build_batch_config" {
    for_each = var.build_batch_config != null ? [var.build_batch_config] : []
    content {
      combine_artifacts = build_batch_config.value.combine_artifacts
      service_role      = build_batch_config.value.service_role
      timeout_in_mins   = build_batch_config.value.timeout_in_mins

      dynamic "restrictions" {
        for_each = build_batch_config.value.restrictions != null ? [build_batch_config.value.restrictions] : []
        content {
          compute_types_allowed  = restrictions.value.compute_types_allowed
          maximum_builds_allowed = restrictions.value.maximum_builds_allowed
        }
      }
    }
  }

  dynamic "cache" {
    for_each = var.cache != null ? [var.cache] : []
    content {
      location = cache.value.location
      modes    = cache.value.modes
      type     = cache.value.type
    }
  }

  environment {
    certificate                 = var.environment.certificate
    compute_type                = var.environment.compute_type
    image                       = var.environment.image
    type                        = var.environment.type
    image_pull_credentials_type = var.environment.image_pull_credentials_type
    privileged_mode             = var.environment.privileged_mode

    dynamic "docker_server" {
      for_each = var.environment.docker_server != null ? [var.environment.docker_server] : []
      content {
        compute_type       = docker_server.value.compute_type
        security_group_ids = docker_server.value.security_group_ids
      }
    }

    dynamic "fleet" {
      for_each = var.environment.fleet != null ? [var.environment.fleet] : []
      content {
        fleet_arn = fleet.value.fleet_arn
      }
    }

    dynamic "environment_variable" {
      for_each = var.environment.environment_variables != null ? var.environment.environment_variables : []
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }

    dynamic "registry_credential" {
      for_each = var.environment.registry_credential != null ? [var.environment.registry_credential] : []
      content {
        credential          = registry_credential.value.credential
        credential_provider = registry_credential.value.credential_provider
      }
    }
  }

  dynamic "file_system_locations" {
    for_each = var.file_system_locations != null ? var.file_system_locations : []
    content {
      identifier    = file_system_locations.value.identifier
      location      = file_system_locations.value.location
      mount_options = file_system_locations.value.mount_options
      mount_point   = file_system_locations.value.mount_point
      type          = file_system_locations.value.type
    }
  }

  dynamic "logs_config" {
    for_each = var.logs_config != null ? [var.logs_config] : []
    content {
      dynamic "cloudwatch_logs" {
        for_each = logs_config.value.cloudwatch_logs != null ? [logs_config.value.cloudwatch_logs] : []
        content {
          group_name  = cloudwatch_logs.value.group_name
          status      = cloudwatch_logs.value.status
          stream_name = cloudwatch_logs.value.stream_name
        }
      }

      dynamic "s3_logs" {
        for_each = logs_config.value.s3_logs != null ? [logs_config.value.s3_logs] : []
        content {
          encryption_disabled = s3_logs.value.encryption_disabled
          location            = s3_logs.value.location
          status              = s3_logs.value.status
          bucket_owner_access = s3_logs.value.bucket_owner_access
        }
      }
    }
  }

  dynamic "secondary_artifacts" {
    for_each = var.secondary_artifacts != null ? var.secondary_artifacts : []
    content {
      artifact_identifier    = secondary_artifacts.value.artifact_identifier
      bucket_owner_access    = secondary_artifacts.value.bucket_owner_access
      encryption_disabled    = secondary_artifacts.value.encryption_disabled
      location               = secondary_artifacts.value.location
      name                   = secondary_artifacts.value.name
      namespace_type         = secondary_artifacts.value.namespace_type
      override_artifact_name = secondary_artifacts.value.override_artifact_name
      packaging              = secondary_artifacts.value.packaging
      path                   = secondary_artifacts.value.path
      type                   = secondary_artifacts.value.type
    }
  }

  dynamic "secondary_sources" {
    for_each = var.secondary_sources != null ? var.secondary_sources : []
    content {
      buildspec           = secondary_sources.value.buildspec
      git_clone_depth     = secondary_sources.value.git_clone_depth
      insecure_ssl        = secondary_sources.value.insecure_ssl
      location            = secondary_sources.value.location
      report_build_status = secondary_sources.value.report_build_status
      source_identifier   = secondary_sources.value.source_identifier
      type                = secondary_sources.value.type

      dynamic "auth" {
        for_each = secondary_sources.value.auth != null ? [secondary_sources.value.auth] : []
        content {
          type     = auth.value.type
          resource = auth.value.resource
        }
      }

      dynamic "git_submodules_config" {
        for_each = secondary_sources.value.git_submodules_config != null ? [secondary_sources.value.git_submodules_config] : []
        content {
          fetch_submodules = git_submodules_config.value.fetch_submodules
        }
      }

      dynamic "build_status_config" {
        for_each = secondary_sources.value.build_status_config != null ? [secondary_sources.value.build_status_config] : []
        content {
          context    = build_status_config.value.context
          target_url = build_status_config.value.target_url
        }
      }
    }
  }

  dynamic "secondary_source_version" {
    for_each = var.secondary_source_version != null ? var.secondary_source_version : []
    content {
      source_identifier = secondary_source_version.value.source_identifier
      source_version    = secondary_source_version.value.source_version
    }
  }

  source {
    buildspec           = var.source_config.buildspec
    git_clone_depth     = var.source_config.git_clone_depth
    insecure_ssl        = var.source_config.insecure_ssl
    location            = var.source_config.location
    report_build_status = var.source_config.report_build_status
    type                = var.source_config.type

    dynamic "auth" {
      for_each = var.source_config.auth != null ? [var.source_config.auth] : []
      content {
        type     = auth.value.type
        resource = auth.value.resource
      }
    }

    dynamic "git_submodules_config" {
      for_each = var.source_config.git_submodules_config != null ? [var.source_config.git_submodules_config] : []
      content {
        fetch_submodules = git_submodules_config.value.fetch_submodules
      }
    }

    dynamic "build_status_config" {
      for_each = var.source_config.build_status_config != null ? [var.source_config.build_status_config] : []
      content {
        context    = build_status_config.value.context
        target_url = build_status_config.value.target_url
      }
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnets            = vpc_config.value.subnets
      vpc_id             = vpc_config.value.vpc_id
    }
  }
}