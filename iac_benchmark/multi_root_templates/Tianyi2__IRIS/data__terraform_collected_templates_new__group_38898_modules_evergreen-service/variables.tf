## ---------------------------------------------------------------------------------------------------------------------
## DNS & Certificate related variables
##
## Each service is capable of running on multiple domains by attaching multiple certificates to the ALB. This is
## useful for example when we want to run a website on both www.example.com and example.com.
## ---------------------------------------------------------------------------------------------------------------------

variable "acm_certificate_arns" {
  type        = list(string)
  description = "List of ACM certificates to attach to the service"
}

variable "domain_names" {
  type        = list(string)
  description = "List of domain names to attach to the service"
}

## ---------------------------------------------------------------------------------------------------------------------
## Host system variables
## ---------------------------------------------------------------------------------------------------------------------

variable "runtime_platform_operating_system" {
  type        = string
  description = "Operating system type for the ECS task"
}

variable "runtime_platform_architecture" {
  type        = string
  description = "Architecture for the ECS task"
}

## ---------------------------------------------------------------------------------------------------------------------
## ECS related variables
##
## The ECS service is the actual service that is being provisioned. All services are deployed into private subnets.
## ---------------------------------------------------------------------------------------------------------------------

variable "service_name" {
  type        = string
  description = "Name of the service"
}

variable "containers" {
  type = list(object({
    container_name = string
    image          = string
    cpu            = number
    memory         = number
    essential      = bool
    environment    = map(string)
    ports = list(object({
      container_port = number
      protocol       = string
    }))
    healthcheck = optional(object({
      command = list(string)
    }))
    networking = optional(object({
      hostname = optional(string)
    }))
  }))
  description = "List of containers to run"
}

variable "task_cpu" {
  type        = number
  description = "CPU to allocate to the task. This is shared across all containers in the task"
}

variable "task_memory" {
  type        = number
  description = "Memory to allocate to the task. This is shared across all containers in the task"
}

variable "task_role_arn" {
  type        = string
  description = "ARN of the task role to use for the service. Use this to give the container access to other AWS resources"
}

variable "task_count" {
  type        = number
  description = "Number of task instances to run"
}

## ---------------------------------------------------------------------------------------------------------------------
## ALB Listener related variables
## ---------------------------------------------------------------------------------------------------------------------

variable "target_group_container_port" {
  type        = number
  description = "Port the container listens on"
}

variable "target_group_container_name" {
  type        = string
  description = "Name of the container"
}

variable "target_group_rule_priority" {
  type        = number
  description = "Priority of the rule"
}

variable "alb_health_check_path" {
  type        = string
  description = "Path to use for the health check"
  default     = "/health"
}

variable "alb_health_check_enabled" {
  type        = bool
  description = "Enable health checks"
  default     = true
}

variable "alb_health_check_timeout" {
  type        = number
  description = "Timeout for the health check"
  default     = 5
}

variable "alb_health_check_grace_period_seconds" {
  type        = number
  description = "Grace period for the health check"
  default     = 60
}

variable "vpc_subnets" {
  type        = list(string)
  description = "VPC Subnets"
}

variable "vpc_security_group" {
  type        = string
  description = "VPC Security Group"
}
