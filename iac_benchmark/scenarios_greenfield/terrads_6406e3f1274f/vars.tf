variable "ami_id" {
  description = "The AMI ID to use in the AWS Batch compute environment. Should be compatible with ECS."
  type        = string
}

variable "result_bucket" {
  description = "A bucket into which we place results from pipeline tasks."
  type        = string
}

variable "max_cpu" {
  description = "The maximum number of vCPUs in the Batch environment"
  type        = number
}

variable "instance_types" {
  description = "The types of instances that are available in the environment. Specific machines can be used to force parallelization in desired ways."
  type        = list(any)
  default     = ["optimal"]
}
