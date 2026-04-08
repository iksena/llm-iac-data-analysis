output "arn" {
  description = "ARN of the task definition."
  value       = data.aws_ecs_task_definition.this.arn
}

output "arn_without_revision" {
  description = "ARN of the Task Definition with the trailing revision removed. This may be useful for situations where the latest task definition is always desired."
  value       = data.aws_ecs_task_definition.this.arn_without_revision
}

output "container_definitions" {
  description = "A list of valid container definitions provided as a single valid JSON document."
  value       = data.aws_ecs_task_definition.this.container_definitions
}

output "cpu" {
  description = "Number of cpu units used by the task. If the requires_compatibilities is FARGATE this field is required."
  value       = data.aws_ecs_task_definition.this.cpu
}

output "enable_fault_injection" {
  description = "Enables fault injection and allows for fault injection requests to be accepted from the task's containers. Default is false."
  value       = data.aws_ecs_task_definition.this.enable_fault_injection
}

output "ephemeral_storage" {
  description = "The amount of ephemeral storage to allocate for the task. This parameter is used to expand the total amount of ephemeral storage available, beyond the default amount, for tasks hosted on AWS Fargate."
  value       = data.aws_ecs_task_definition.this.ephemeral_storage
}

output "execution_role_arn" {
  description = "ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume."
  value       = data.aws_ecs_task_definition.this.execution_role_arn
}

output "family" {
  description = "A unique name for your task definition."
  value       = data.aws_ecs_task_definition.this.family
}

output "ipc_mode" {
  description = "IPC resource namespace to be used for the containers in the task The valid values are host, task, and none."
  value       = data.aws_ecs_task_definition.this.ipc_mode
}

output "memory" {
  description = "Amount (in MiB) of memory used by the task. If the requires_compatibilities is FARGATE this field is required."
  value       = data.aws_ecs_task_definition.this.memory
}

output "network_mode" {
  description = "Docker networking mode to use for the containers in the task. Valid values are none, bridge, awsvpc, and host."
  value       = data.aws_ecs_task_definition.this.network_mode
}

output "pid_mode" {
  description = "Process namespace to use for the containers in the task. The valid values are host and task."
  value       = data.aws_ecs_task_definition.this.pid_mode
}

output "placement_constraints" {
  description = "Configuration block for rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10."
  value       = data.aws_ecs_task_definition.this.placement_constraints
}

output "proxy_configuration" {
  description = "Configuration block for the App Mesh proxy."
  value       = data.aws_ecs_task_definition.this.proxy_configuration
}

output "requires_compatibilities" {
  description = "Set of launch types required by the task. The valid values are EC2 and FARGATE."
  value       = data.aws_ecs_task_definition.this.requires_compatibilities
}

output "revision" {
  description = "Revision of the task in a particular family."
  value       = data.aws_ecs_task_definition.this.revision
}

output "runtime_platform" {
  description = "Configuration block for runtime_platform that containers in your task may use."
  value       = data.aws_ecs_task_definition.this.runtime_platform
}

output "status" {
  description = "Status of the task definition."
  value       = data.aws_ecs_task_definition.this.status
}

output "task_role_arn" {
  description = "ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  value       = data.aws_ecs_task_definition.this.task_role_arn
}

output "volume" {
  description = "Configuration block for volumes that containers in your task may use."
  value       = data.aws_ecs_task_definition.this.volume
}