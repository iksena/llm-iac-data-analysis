output "arn" {
  description = "Full ARN of the Task Definition (including both family and revision)"
  value       = aws_ecs_task_definition.this.arn
}

output "arn_without_revision" {
  description = "ARN of the Task Definition with the trailing revision removed"
  value       = aws_ecs_task_definition.this.arn_without_revision
}

output "revision" {
  description = "Revision of the task in a particular family"
  value       = aws_ecs_task_definition.this.revision
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ecs_task_definition.this.tags_all
}

output "family" {
  description = "A unique name for your task definition"
  value       = aws_ecs_task_definition.this.family
}

output "container_definitions" {
  description = "A list of valid container definitions provided as a single valid JSON document"
  value       = aws_ecs_task_definition.this.container_definitions
}

output "region" {
  description = "Region where this resource will be managed"
  value       = aws_ecs_task_definition.this.region
}

output "cpu" {
  description = "Number of cpu units used by the task"
  value       = aws_ecs_task_definition.this.cpu
}

output "enable_fault_injection" {
  description = "Enables fault injection and allows for fault injection requests to be accepted from the task's containers"
  value       = aws_ecs_task_definition.this.enable_fault_injection
}

output "execution_role_arn" {
  description = "ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume"
  value       = aws_ecs_task_definition.this.execution_role_arn
}

output "ipc_mode" {
  description = "IPC resource namespace to be used for the containers in the task"
  value       = aws_ecs_task_definition.this.ipc_mode
}

output "memory" {
  description = "Amount (in MiB) of memory used by the task"
  value       = aws_ecs_task_definition.this.memory
}

output "network_mode" {
  description = "Docker networking mode to use for the containers in the task"
  value       = aws_ecs_task_definition.this.network_mode
}

output "runtime_platform" {
  description = "Configuration block for runtime_platform that containers in your task may use"
  value       = aws_ecs_task_definition.this.runtime_platform
}

output "pid_mode" {
  description = "Process namespace to use for the containers in the task"
  value       = aws_ecs_task_definition.this.pid_mode
}

output "placement_constraints" {
  description = "Configuration block for rules that are taken into consideration during task placement"
  value       = aws_ecs_task_definition.this.placement_constraints
}

output "proxy_configuration" {
  description = "Configuration block for the App Mesh proxy"
  value       = aws_ecs_task_definition.this.proxy_configuration
}

output "ephemeral_storage" {
  description = "The amount of ephemeral storage to allocate for the task"
  value       = aws_ecs_task_definition.this.ephemeral_storage
}

output "requires_compatibilities" {
  description = "Set of launch types required by the task"
  value       = aws_ecs_task_definition.this.requires_compatibilities
}

output "skip_destroy" {
  description = "Whether to retain the old revision when the resource is destroyed or replacement is necessary"
  value       = aws_ecs_task_definition.this.skip_destroy
}

output "tags" {
  description = "Key-value map of resource tags"
  value       = aws_ecs_task_definition.this.tags
}

output "task_role_arn" {
  description = "ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services"
  value       = aws_ecs_task_definition.this.task_role_arn
}

output "track_latest" {
  description = "Whether should track latest ACTIVE task definition on AWS or the one created with the resource stored in state"
  value       = aws_ecs_task_definition.this.track_latest
}

output "volume" {
  description = "Configuration block for volumes that containers in your task may use"
  value       = aws_ecs_task_definition.this.volume
}