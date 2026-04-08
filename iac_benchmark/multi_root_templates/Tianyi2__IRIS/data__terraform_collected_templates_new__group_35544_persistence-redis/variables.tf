variable "kubernetes_tenant_namespace" {
  type = string
}
variable "kubernetes_mc_resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "pv_redis_master_disk_source_existing" {
  type = bool
}
variable "pv_redis_replica_disk_source_existing" {
  type = bool
}
variable "pv_redis_storage_gbi" {
  type = number
}
variable "pv_redis_storage_account_type" {
  type = string
}
variable "pv_redis_storage_class_name" {
  type = string
}
variable "pv_redis_provider" {
  type = string
}
variable "pv_redis_disk_master_name" {
  type = string
}
variable "pv_redis_disk_replica_name" {
  type = string
}
variable "project_stage" {
  description = "The platform stage"
  type = string
}
variable "customer_name" {
  description = "The customer name"
  type        = string
}
variable "project_name" {
  description = "The project name"
  type        = string
}
variable "cost_center" {
  type    = string
}