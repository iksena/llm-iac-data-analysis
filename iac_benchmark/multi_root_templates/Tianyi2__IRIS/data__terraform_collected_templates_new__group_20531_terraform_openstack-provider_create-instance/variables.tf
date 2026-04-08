variable "image_id" {
  description = "The image id"
  type        = string
  default     = "4d34f5e6-e891-4fa9-ab57-b9ea203cfefb"
}

variable "flavor_name" {
  description = "the flavor name"
  type        = string
  default     = "Small"
}

variable "key_pair_name" {
  description = "the key_pair name"
  type        = string
  default     = "Ahmad"
}

variable "network_name" {
  description = "the network name"
  type        = string
  default     = "Public"
}

variable "volume_type" {
  description = "the volume_type name"
  type        = string
  default     = "__DEFAULT__"
}