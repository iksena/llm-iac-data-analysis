variable "region" { default = "eu-central-1" }
variable "cluster_name" { default = "chatroom-cluster-tf" }
variable "bucket_name" { default = "chatroom-bucket-tf" }
variable "service_name" { default = "chatroom-service-tf" }
variable "task_name" { default = "chatroom-task-tf" }
variable "allowed_origin" {
  description = "The URL that frontend will be served from (for CORS)"
  type        = string
  default     = "https://d3qcwu8fbtx7w0.cloudfront.net"
}

