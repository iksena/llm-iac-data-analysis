variable "enabled" {
  default = true
}

variable "prefix" { default = "benchmark" }
variable "owner" { default = "benchmark-owner" }

variable "gatling_ecs_cluster_name" { default = "benchmark-gatling-cluster" }
variable "gatling_s3_log_bucket_name" { default = "benchmark-gatling-log-bucket-tf5x" }

variable "gatling_runner_ecr_name" { default = "benchmark-gatling-runner" }
variable "gatling_s3_reporter_ecr_name" { default = "benchmark-gatling-reporter" }
variable "gatling_aggregate_runner_ecr_name" { default = "benchmark-gatling-aggregate-runner" }

