output "image" {
  description = "Docker image in use, including the digest"
  value       = data.aws_ecs_container_definition.this.image
}

output "image_digest" {
  description = "Digest of the docker image in use"
  value       = data.aws_ecs_container_definition.this.image_digest
}

output "cpu" {
  description = "CPU limit for this container definition"
  value       = data.aws_ecs_container_definition.this.cpu
}

output "memory" {
  description = "Memory limit for this container definition"
  value       = data.aws_ecs_container_definition.this.memory
}

output "memory_reservation" {
  description = "Soft limit (in MiB) of memory to reserve for the container"
  value       = data.aws_ecs_container_definition.this.memory_reservation
}

output "environment" {
  description = "Environment in use"
  value       = data.aws_ecs_container_definition.this.environment
}

output "disable_networking" {
  description = "Indicator if networking is disabled"
  value       = data.aws_ecs_container_definition.this.disable_networking
}

output "docker_labels" {
  description = "Set docker labels"
  value       = data.aws_ecs_container_definition.this.docker_labels
}