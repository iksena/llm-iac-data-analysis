variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "access_point_id" {
  description = "ID or ARN of the access point whose mount target that you want to find"
  type        = string
  default     = null

}

variable "file_system_id" {
  description = "ID or ARN of the file system whose mount target that you want to find"
  type        = string
  default     = null

}

variable "mount_target_id" {
  description = "ID or ARN of the mount target that you want to find"
  type        = string
  default     = null

}