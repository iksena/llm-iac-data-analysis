# common parameter
variable "tags" {
  description = "リソース群に付与する共通タグ"
  type        = map(string)
  default     = {}
}

variable "base_name" {
  description = "作成するリソースに付与する接頭語"
  type        = string
  default     = "benchmark"
}

# module parameter
variable "vpc_cidr" {
  description = "VPCのネットワークアドレス帯"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_public_cidrs" {
  description = "パブリックサブネットのアドレス帯"
  type        = list(string)
  default     = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "subnet_private_cidrs" {
  description = "プライベートサブネットのアドレス帯"
  type        = list(string)
  default     = null
}
