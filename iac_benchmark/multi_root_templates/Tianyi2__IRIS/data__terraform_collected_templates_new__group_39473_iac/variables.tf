variable "env" {
  type        = string
  description = "Environment being deployed"
}

variable "location" {
  type        = string
  description = "The Azure Region in which all resources should be created."
}

variable "ip_address" {
  type        = string
  description = "IP address to allow in MSSQL firewall rule"
}

variable "servicebus_topics" {
  description = "Servicebus topics needed in the solution"
  default     = ["environment-created", "feature-toggle-created", "feature-toggle-updated", "feature-group-updated"]
}

variable "servicebus_queues" {
  description = "Servicebus queues needed in the solution"
  default     = ["create-feature-toggle"]
}

variable "api_servicebus_subscriptions" {
  description = "API Servicebus subscriptions needed in the solution"
  default     = ["environment-created", "feature-toggle-created"]
}

variable "func_servicebus_subscriptions" {
  description = "Function Servicebus subscriptions needed in the solution"
  default     = ["feature-toggle-updated", "feature-group-updated"]
}
