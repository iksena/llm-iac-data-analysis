################################################################################
# General Variables
################################################################################

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)."

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "region" {
  type        = string
  description = "AWS region."

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "Region must be a valid AWS region identifier (e.g., us-east-1)."
  }
}

variable "domain_name" {
  type        = string
  description = "Domain name for the application (optional)."
  default     = null
}

################################################################################
# Network Variables
################################################################################

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC."

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr_block))
    error_message = "VPC CIDR block must be a valid CIDR notation."
  }
}

variable "public_subnets" {
  description = "Public subnet definitions."
  type = map(object({
    cidr_block = string
    az         = string
  }))
}

variable "private_subnets" {
  description = "Private subnet definitions."
  type = map(object({
    cidr_block = string
    az         = string
  }))
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Enable NAT Gateway for private subnets."
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use a single NAT Gateway (cost savings for non-prod)."
  default     = true
}

variable "enable_s3_endpoint" {
  type        = bool
  description = "Enable S3 VPC Gateway Endpoint."
  default     = true
}

variable "enable_ecr_endpoints" {
  type        = bool
  description = "Enable ECR VPC Interface Endpoints."
  default     = true
}

variable "enable_logs_endpoint" {
  type        = bool
  description = "Enable CloudWatch Logs VPC Interface Endpoint."
  default     = true
}

variable "enable_secretsmanager_endpoint" {
  type        = bool
  description = "Enable Secrets Manager VPC Interface Endpoint."
  default     = false
}

variable "enable_flow_logs" {
  type        = bool
  description = "Enable VPC Flow Logs."
  default     = false
}

variable "flow_logs_retention_days" {
  type        = number
  description = "Flow logs retention period in days."
  default     = 14
}

################################################################################
# ECS Cluster Variables
################################################################################

variable "enable_container_insights" {
  type        = bool
  description = "Enable Container Insights for ECS cluster."
  default     = true
}

################################################################################
# ALB Variables
################################################################################

variable "enable_https" {
  type        = bool
  description = "Enable HTTPS on the ALB."
  default     = false
}

variable "acm_certificate_arn" {
  type        = string
  description = "ACM certificate ARN for HTTPS (required if enable_https is true)."
  default     = null
}

variable "ssl_policy" {
  type        = string
  description = "SSL policy for the HTTPS listener."
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "alb_enable_deletion_protection" {
  type        = bool
  description = "Enable deletion protection for the ALB."
  default     = false
}

variable "alb_idle_timeout" {
  type        = number
  description = "ALB idle timeout in seconds."
  default     = 60
}

variable "alb_access_logs_bucket" {
  type        = string
  description = "S3 bucket for ALB access logs."
  default     = null
}

variable "alb_access_logs_prefix" {
  type        = string
  description = "S3 prefix for ALB access logs."
  default     = "alb-logs"
}

################################################################################
# S3 Variables
################################################################################

variable "app_s3_bucket_name" {
  type        = string
  description = "S3 bucket name for application data (must be globally unique)."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.app_s3_bucket_name))
    error_message = "Bucket name must contain only lowercase letters, numbers, hyphens, and periods."
  }
}

variable "app_s3_versioning_enabled" {
  type        = bool
  description = "Enable versioning on the S3 bucket."
  default     = true
}

variable "app_s3_enable_public_read" {
  type        = bool
  description = "Whether to enable public read on uploads prefix."
  default     = false
}

variable "app_s3_public_read_prefix" {
  type        = string
  description = "Prefix to allow public read (e.g., uploads/)."
  default     = "uploads/"
}

variable "app_s3_enable_cloudfront" {
  type        = bool
  description = "Whether to provision a CloudFront distribution for the app bucket."
  default     = true
}

variable "app_s3_cloudfront_price_class" {
  type        = string
  description = "Price class for CloudFront."
  default     = "PriceClass_100"
}

variable "app_s3_cloudfront_aliases" {
  type        = list(string)
  description = "Alternative domain names (CNAMEs) for CloudFront."
  default     = []
}

variable "app_s3_cloudfront_certificate_arn" {
  type        = string
  description = "ACM certificate ARN for CloudFront (required if using aliases)."
  default     = null
}

variable "app_s3_enable_intelligent_tiering" {
  type        = bool
  description = "Enable automatic transition to Intelligent-Tiering."
  default     = false
}

variable "app_s3_lifecycle_rules" {
  type = list(object({
    id                                     = string
    enabled                                = optional(bool, true)
    prefix                                 = optional(string, "")
    expiration_days                        = optional(number)
    noncurrent_version_expiration_days     = optional(number)
    abort_incomplete_multipart_upload_days = optional(number, 7)
    transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
    noncurrent_version_transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
  }))
  description = "List of lifecycle rules for the S3 bucket."
  default     = []
}

################################################################################
# Database Variables
################################################################################

variable "db_name" {
  type        = string
  description = "Database name."
}

variable "db_username" {
  type        = string
  description = "Database admin username."
}

variable "db_password" {
  type        = string
  description = "Database admin password (not used if manage_master_user_password is true)."
  sensitive   = true
  default     = null
}

variable "db_manage_master_user_password" {
  type        = bool
  description = "Let AWS manage the master user password in Secrets Manager."
  default     = false
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class."
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  type        = number
  description = "Allocated storage in GB."
  default     = 20
}

variable "db_max_allocated_storage" {
  type        = number
  description = "Maximum allocated storage for autoscaling in GB."
  default     = 100
}

variable "db_storage_type" {
  type        = string
  description = "Storage type (gp2, gp3, io1)."
  default     = "gp3"
}

variable "db_engine_version" {
  type        = string
  description = "PostgreSQL engine version."
  default     = "16"
}

variable "db_multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment."
  default     = false
}

variable "db_backup_retention_period" {
  type        = number
  description = "Backup retention period in days."
  default     = 7
}

variable "db_deletion_protection" {
  type        = bool
  description = "Enable deletion protection."
  default     = false
}

variable "db_enable_performance_insights" {
  type        = bool
  description = "Enable Performance Insights."
  default     = false
}

variable "db_enable_enhanced_monitoring" {
  type        = bool
  description = "Enable Enhanced Monitoring."
  default     = false
}

variable "db_monitoring_interval" {
  type        = number
  description = "Enhanced Monitoring interval in seconds."
  default     = 60
}

################################################################################
# Redis Variables
################################################################################

variable "redis_node_type" {
  type        = string
  description = "ElastiCache node type."
  default     = "cache.t3.micro"
}

variable "redis_num_cache_clusters" {
  type        = number
  description = "Number of cache clusters (nodes)."
  default     = 1
}

variable "redis_engine_version" {
  type        = string
  description = "Redis engine version."
  default     = "7.1"
}

variable "redis_automatic_failover_enabled" {
  type        = bool
  description = "Enable automatic failover (requires num_cache_clusters >= 2)."
  default     = false
}

variable "redis_transit_encryption_enabled" {
  type        = bool
  description = "Enable in-transit encryption."
  default     = true
}

################################################################################
# Container Image Variables
################################################################################

variable "container_registry" {
  type        = string
  description = "Container registry URL (e.g., ghcr.io/fullstackhero)."
  default     = "ghcr.io/fullstackhero"
}

variable "container_image_tag" {
  type        = string
  description = "Container image tag (shared across all services)."
}

variable "api_image_name" {
  type        = string
  description = "API container image name (without registry or tag)."
  default     = "fsh-playground-api"
}

variable "blazor_image_name" {
  type        = string
  description = "Blazor container image name (without registry or tag)."
  default     = "fsh-playground-blazor"
}

################################################################################
# API Service Variables
################################################################################

variable "api_container_port" {
  type        = number
  description = "API container port."
  default     = 8080
}

variable "api_cpu" {
  type        = string
  description = "API CPU units."
  default     = "256"
}

variable "api_memory" {
  type        = string
  description = "API memory."
  default     = "512"
}

variable "api_desired_count" {
  type        = number
  description = "Desired API task count."
  default     = 1
}

variable "api_health_check_healthy_threshold" {
  type        = number
  description = "Number of consecutive health checks required for healthy status."
  default     = 2
}

variable "api_deregistration_delay" {
  type        = number
  description = "Target group deregistration delay in seconds."
  default     = 30
}

variable "api_enable_circuit_breaker" {
  type        = bool
  description = "Enable deployment circuit breaker."
  default     = true
}

variable "api_use_fargate_spot" {
  type        = bool
  description = "Use Fargate Spot capacity."
  default     = false
}

variable "api_extra_environment_variables" {
  type        = map(string)
  description = "Additional environment variables for API."
  default     = {}
}

################################################################################
# Blazor Service Variables
################################################################################

variable "blazor_container_port" {
  type        = number
  description = "Blazor container port."
  default     = 8080
}

variable "blazor_cpu" {
  type        = string
  description = "Blazor CPU units."
  default     = "256"
}

variable "blazor_memory" {
  type        = string
  description = "Blazor memory."
  default     = "512"
}

variable "blazor_desired_count" {
  type        = number
  description = "Desired Blazor task count."
  default     = 1
}

variable "blazor_health_check_healthy_threshold" {
  type        = number
  description = "Number of consecutive health checks required for healthy status."
  default     = 2
}

variable "blazor_deregistration_delay" {
  type        = number
  description = "Target group deregistration delay in seconds."
  default     = 30
}

variable "blazor_enable_circuit_breaker" {
  type        = bool
  description = "Enable deployment circuit breaker."
  default     = true
}

variable "blazor_use_fargate_spot" {
  type        = bool
  description = "Use Fargate Spot capacity."
  default     = false
}

variable "blazor_extra_environment_variables" {
  type        = map(string)
  description = "Additional environment variables for Blazor."
  default     = {}
}
