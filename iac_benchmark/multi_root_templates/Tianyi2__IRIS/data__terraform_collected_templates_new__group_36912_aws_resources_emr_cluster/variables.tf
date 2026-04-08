variable "name" {
  description = "Name of the job flow."
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_emr_cluster, name must not be empty."
  }
}

variable "release_label" {
  description = "Release label for the Amazon EMR release."
  type        = string
  validation {
    condition     = length(var.release_label) > 0
    error_message = "resource_aws_emr_cluster, release_label must not be empty."
  }
}

variable "service_role" {
  description = "IAM role that will be assumed by the Amazon EMR service to access AWS resources."
  type        = string
  validation {
    condition     = length(var.service_role) > 0
    error_message = "resource_aws_emr_cluster, service_role must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "additional_info" {
  description = "JSON string for selecting additional features such as adding proxy information. Note: Currently there is no API to retrieve the value of this argument after EMR cluster creation from provider, therefore Terraform cannot detect drift from the actual EMR cluster if its value is changed outside Terraform."
  type        = string
  default     = null
}

variable "applications" {
  description = "A case-insensitive list of applications for Amazon EMR to install and configure when launching the cluster. For a list of applications available for each Amazon EMR release version, see the Amazon EMR Release Guide."
  type        = list(string)
  default     = null
}

variable "autoscaling_role" {
  description = "IAM role for automatic scaling policies. The IAM role provides permissions that the automatic scaling feature requires to launch and terminate EC2 instances in an instance group."
  type        = string
  default     = null
}

variable "auto_termination_policy" {
  description = "An auto-termination policy for an Amazon EMR cluster. An auto-termination policy defines the amount of idle time in seconds after which a cluster automatically terminates."
  type = object({
    idle_timeout = optional(number)
  })
  default = null
  validation {
    condition = var.auto_termination_policy == null || (
      var.auto_termination_policy.idle_timeout == null ||
      (var.auto_termination_policy.idle_timeout >= 60 && var.auto_termination_policy.idle_timeout <= 604800)
    )
    error_message = "resource_aws_emr_cluster, auto_termination_policy idle_timeout must be between 60 and 604800 seconds."
  }
}

variable "bootstrap_action" {
  description = "Ordered list of bootstrap actions that will be run before Hadoop is started on the cluster nodes."
  type = list(object({
    name = string
    path = string
    args = optional(list(string))
  }))
  default = []
  validation {
    condition = alltrue([
      for action in var.bootstrap_action :
      length(action.name) > 0 && length(action.path) > 0
    ])
    error_message = "resource_aws_emr_cluster, bootstrap_action name and path must not be empty."
  }
}

variable "configurations" {
  description = "List of configurations supplied for the EMR cluster you are creating. Supply a configuration object for applications to override their default configuration."
  type = list(object({
    classification = optional(string)
    properties     = optional(map(string))
  }))
  default = []
}

variable "configurations_json" {
  description = "JSON string for supplying list of configurations for the EMR cluster."
  type        = string
  default     = null
}

variable "core_instance_fleet" {
  description = "Configuration block to use an Instance Fleet for the core node type. Cannot be specified if any core_instance_group configuration blocks are set."
  type = object({
    name                      = optional(string)
    target_on_demand_capacity = optional(number)
    target_spot_capacity      = optional(number)
    instance_type_configs = optional(list(object({
      instance_type                              = string
      bid_price                                  = optional(string)
      bid_price_as_percentage_of_on_demand_price = optional(number)
      weighted_capacity                          = optional(number)
      configurations = optional(list(object({
        classification = optional(string)
        properties     = optional(map(string))
      })), [])
      ebs_config = optional(list(object({
        iops                 = optional(number)
        size                 = number
        type                 = string
        throughput           = optional(number)
        volumes_per_instance = optional(number)
      })), [])
    })), [])
    launch_specifications = optional(object({
      on_demand_specification = optional(object({
        allocation_strategy = string
      }))
      spot_specification = optional(object({
        allocation_strategy      = string
        block_duration_minutes   = optional(number)
        timeout_action           = string
        timeout_duration_minutes = number
      }))
    }))
  })
  default = null
  validation {
    condition = var.core_instance_fleet == null || alltrue([
      for config in var.core_instance_fleet.instance_type_configs :
      length(config.instance_type) > 0
    ])
    error_message = "resource_aws_emr_cluster, core_instance_fleet instance_type must not be empty."
  }
  validation {
    condition = var.core_instance_fleet == null || (
      var.core_instance_fleet.launch_specifications == null ||
      var.core_instance_fleet.launch_specifications.spot_specification == null ||
      (
        var.core_instance_fleet.launch_specifications.spot_specification.block_duration_minutes == null ||
        contains([60, 120, 180, 240, 300, 360], var.core_instance_fleet.launch_specifications.spot_specification.block_duration_minutes)
      )
    )
    error_message = "resource_aws_emr_cluster, core_instance_fleet spot_specification block_duration_minutes must be one of: 60, 120, 180, 240, 300, 360."
  }
  validation {
    condition = var.core_instance_fleet == null || (
      var.core_instance_fleet.launch_specifications == null ||
      var.core_instance_fleet.launch_specifications.spot_specification == null ||
      contains(["TERMINATE_CLUSTER", "SWITCH_TO_ON_DEMAND"], var.core_instance_fleet.launch_specifications.spot_specification.timeout_action)
    )
    error_message = "resource_aws_emr_cluster, core_instance_fleet spot_specification timeout_action must be TERMINATE_CLUSTER or SWITCH_TO_ON_DEMAND."
  }
  validation {
    condition = var.core_instance_fleet == null || (
      var.core_instance_fleet.launch_specifications == null ||
      var.core_instance_fleet.launch_specifications.spot_specification == null ||
      (
        var.core_instance_fleet.launch_specifications.spot_specification.timeout_duration_minutes >= 5 &&
        var.core_instance_fleet.launch_specifications.spot_specification.timeout_duration_minutes <= 1440
      )
    )
    error_message = "resource_aws_emr_cluster, core_instance_fleet spot_specification timeout_duration_minutes must be between 5 and 1440."
  }
}

variable "core_instance_group" {
  description = "Configuration block to use an Instance Group for the core node type."
  type = object({
    instance_type      = string
    autoscaling_policy = optional(string)
    bid_price          = optional(string)
    instance_count     = optional(number)
    name               = optional(string)
    ebs_config = optional(list(object({
      iops                 = optional(number)
      size                 = number
      type                 = string
      throughput           = optional(number)
      volumes_per_instance = optional(number)
    })), [])
  })
  default = null
  validation {
    condition     = var.core_instance_group == null || length(var.core_instance_group.instance_type) > 0
    error_message = "resource_aws_emr_cluster, core_instance_group instance_type must not be empty."
  }
  validation {
    condition = var.core_instance_group == null || (
      var.core_instance_group.instance_count == null ||
      var.core_instance_group.instance_count >= 1
    )
    error_message = "resource_aws_emr_cluster, core_instance_group instance_count must be at least 1."
  }
  validation {
    condition = var.core_instance_group == null || alltrue([
      for config in var.core_instance_group.ebs_config :
      config.size > 0 && length(config.type) > 0
    ])
    error_message = "resource_aws_emr_cluster, core_instance_group ebs_config size must be greater than 0 and type must not be empty."
  }
  validation {
    condition = var.core_instance_group == null || alltrue([
      for config in var.core_instance_group.ebs_config :
      contains(["gp3", "gp2", "io1", "io2", "standard", "st1", "sc1"], config.type)
    ])
    error_message = "resource_aws_emr_cluster, core_instance_group ebs_config type must be one of: gp3, gp2, io1, io2, standard, st1, sc1."
  }
}

variable "custom_ami_id" {
  description = "Custom Amazon Linux AMI for the cluster (instead of an EMR-owned AMI). Available in Amazon EMR version 5.7.0 and later."
  type        = string
  default     = null
}

variable "ebs_root_volume_size" {
  description = "Size in GiB of the EBS root device volume of the Linux AMI that is used for each EC2 instance. Available in Amazon EMR version 4.x and later."
  type        = number
  default     = null
  validation {
    condition     = var.ebs_root_volume_size == null || var.ebs_root_volume_size > 0
    error_message = "resource_aws_emr_cluster, ebs_root_volume_size must be greater than 0."
  }
}

variable "ec2_attributes" {
  description = "Attributes for the EC2 instances running the job flow."
  type = object({
    instance_profile                  = string
    additional_master_security_groups = optional(string)
    additional_slave_security_groups  = optional(string)
    emr_managed_master_security_group = optional(string)
    emr_managed_slave_security_group  = optional(string)
    key_name                          = optional(string)
    service_access_security_group     = optional(string)
    subnet_id                         = optional(string)
    subnet_ids                        = optional(list(string))
  })
  default = null
  validation {
    condition     = var.ec2_attributes == null || length(var.ec2_attributes.instance_profile) > 0
    error_message = "resource_aws_emr_cluster, ec2_attributes instance_profile must not be empty."
  }
}

variable "keep_job_flow_alive_when_no_steps" {
  description = "Switch on/off run cluster with no steps or when all steps are complete (default is on)."
  type        = bool
  default     = null
}

variable "kerberos_attributes" {
  description = "Kerberos configuration for the cluster."
  type = object({
    kdc_admin_password                   = string
    realm                                = string
    ad_domain_join_password              = optional(string)
    ad_domain_join_user                  = optional(string)
    cross_realm_trust_principal_password = optional(string)
  })
  default = null
  validation {
    condition = var.kerberos_attributes == null || (
      length(var.kerberos_attributes.kdc_admin_password) > 0 &&
      length(var.kerberos_attributes.realm) > 0
    )
    error_message = "resource_aws_emr_cluster, kerberos_attributes kdc_admin_password and realm must not be empty."
  }
}

variable "list_steps_states" {
  description = "List of step states used to filter returned steps."
  type        = list(string)
  default     = null
}

variable "log_encryption_kms_key_id" {
  description = "AWS KMS customer master key (CMK) key ID or arn used for encrypting log files. This attribute is only available with EMR version 5.30.0 and later, excluding EMR 6.0.0."
  type        = string
  default     = null
}

variable "log_uri" {
  description = "S3 bucket to write the log files of the job flow. If a value is not provided, logs are not created."
  type        = string
  default     = null
}

variable "master_instance_fleet" {
  description = "Configuration block to use an Instance Fleet for the master node type. Cannot be specified if any master_instance_group configuration blocks are set."
  type = object({
    name                      = optional(string)
    target_on_demand_capacity = optional(number)
    target_spot_capacity      = optional(number)
    instance_type_configs = optional(list(object({
      instance_type                              = string
      bid_price                                  = optional(string)
      bid_price_as_percentage_of_on_demand_price = optional(number)
      weighted_capacity                          = optional(number)
      configurations = optional(list(object({
        classification = optional(string)
        properties     = optional(map(string))
      })), [])
      ebs_config = optional(list(object({
        iops                 = optional(number)
        size                 = number
        type                 = string
        throughput           = optional(number)
        volumes_per_instance = optional(number)
      })), [])
    })), [])
    launch_specifications = optional(object({
      on_demand_specification = optional(object({
        allocation_strategy = string
      }))
      spot_specification = optional(object({
        allocation_strategy      = string
        block_duration_minutes   = optional(number)
        timeout_action           = string
        timeout_duration_minutes = number
      }))
    }))
  })
  default = null
  validation {
    condition = var.master_instance_fleet == null || alltrue([
      for config in var.master_instance_fleet.instance_type_configs :
      length(config.instance_type) > 0
    ])
    error_message = "resource_aws_emr_cluster, master_instance_fleet instance_type must not be empty."
  }
}

variable "master_instance_group" {
  description = "Configuration block to use an Instance Group for the master node type."
  type = object({
    instance_type  = string
    bid_price      = optional(string)
    instance_count = optional(number)
    name           = optional(string)
    ebs_config = optional(list(object({
      iops                 = optional(number)
      size                 = number
      type                 = string
      throughput           = optional(number)
      volumes_per_instance = optional(number)
    })), [])
  })
  default = null
  validation {
    condition     = var.master_instance_group == null || length(var.master_instance_group.instance_type) > 0
    error_message = "resource_aws_emr_cluster, master_instance_group instance_type must not be empty."
  }
  validation {
    condition = var.master_instance_group == null || (
      var.master_instance_group.instance_count == null ||
      (var.master_instance_group.instance_count == 1 || var.master_instance_group.instance_count == 3)
    )
    error_message = "resource_aws_emr_cluster, master_instance_group instance_count must be 1 or 3."
  }
  validation {
    condition = var.master_instance_group == null || alltrue([
      for config in var.master_instance_group.ebs_config :
      contains(["gp3", "gp2", "io1", "io2", "standard", "st1", "sc1"], config.type)
    ])
    error_message = "resource_aws_emr_cluster, master_instance_group ebs_config type must be one of: gp3, gp2, io1, io2, standard, st1, sc1."
  }
}

variable "os_release_label" {
  description = "Amazon Linux release for all nodes in a cluster launch RunJobFlow request. If not specified, Amazon EMR uses the latest validated Amazon Linux release for cluster launch."
  type        = string
  default     = null
}

variable "placement_group_config" {
  description = "The specified placement group configuration for an Amazon EMR cluster."
  type = list(object({
    instance_role      = string
    placement_strategy = optional(string)
  }))
  default = []
  validation {
    condition = alltrue([
      for config in var.placement_group_config :
      contains(["MASTER", "CORE", "TASK"], config.instance_role)
    ])
    error_message = "resource_aws_emr_cluster, placement_group_config instance_role must be one of: MASTER, CORE, TASK."
  }
  validation {
    condition = alltrue([
      for config in var.placement_group_config :
      config.placement_strategy == null || contains(["SPREAD", "PARTITION", "CLUSTER", "NONE"], config.placement_strategy)
    ])
    error_message = "resource_aws_emr_cluster, placement_group_config placement_strategy must be one of: SPREAD, PARTITION, CLUSTER, NONE."
  }
}

variable "scale_down_behavior" {
  description = "Way that individual Amazon EC2 instances terminate when an automatic scale-in activity occurs or an instance group is resized."
  type        = string
  default     = null
}

variable "security_configuration" {
  description = "Security configuration name to attach to the EMR cluster. Only valid for EMR clusters with release_label 4.8.0 or greater."
  type        = string
  default     = null
}

variable "step" {
  description = "List of steps to run when creating the cluster."
  type = list(object({
    action_on_failure = string
    name              = string
    hadoop_jar_step = object({
      jar        = string
      args       = optional(list(string))
      main_class = optional(string)
      properties = optional(map(string))
    })
  }))
  default = []
  validation {
    condition = alltrue([
      for step in var.step :
      contains(["TERMINATE_JOB_FLOW", "TERMINATE_CLUSTER", "CANCEL_AND_WAIT", "CONTINUE"], step.action_on_failure)
    ])
    error_message = "resource_aws_emr_cluster, step action_on_failure must be one of: TERMINATE_JOB_FLOW, TERMINATE_CLUSTER, CANCEL_AND_WAIT, CONTINUE."
  }
  validation {
    condition = alltrue([
      for step in var.step :
      length(step.name) > 0 && length(step.hadoop_jar_step.jar) > 0
    ])
    error_message = "resource_aws_emr_cluster, step name and hadoop_jar_step jar must not be empty."
  }
}

variable "step_concurrency_level" {
  description = "Number of steps that can be executed concurrently. You can specify a maximum of 256 steps. Only valid for EMR clusters with release_label 5.28.0 or greater (default is 1)."
  type        = number
  default     = null
  validation {
    condition     = var.step_concurrency_level == null || (var.step_concurrency_level >= 1 && var.step_concurrency_level <= 256)
    error_message = "resource_aws_emr_cluster, step_concurrency_level must be between 1 and 256."
  }
}

variable "tags" {
  description = "List of tags to apply to the EMR Cluster."
  type        = map(string)
  default     = null
}

variable "termination_protection" {
  description = "Switch on/off termination protection (default is false, except when using multiple master nodes). Before attempting to destroy the resource when termination protection is enabled, this configuration must be applied with its value set to false."
  type        = bool
  default     = null
}

variable "unhealthy_node_replacement" {
  description = "Whether whether Amazon EMR should gracefully replace core nodes that have degraded within the cluster. Default value is false."
  type        = bool
  default     = null
}

variable "visible_to_all_users" {
  description = "Whether the job flow is visible to all IAM users of the AWS account associated with the job flow. Default value is true."
  type        = bool
  default     = null
}