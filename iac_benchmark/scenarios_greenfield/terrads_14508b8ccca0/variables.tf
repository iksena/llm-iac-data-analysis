# Variables for Config Delivery channel
variable "name" { default = "benchmark-config-channel" }

variable "s3_bucket_name" { default = "benchmark-config-bucket-tf5x" }
variable "s3_key_prefix" { default = "config" }
variable "delivery_frequency" { default = "TwentyFour_Hours" }
