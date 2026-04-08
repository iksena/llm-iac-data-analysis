variable "location" {
  description = "Variavel que indica a regiao onde os recursos vao ser craidos"
  type        = string
  default     = "Brazil South"
}

variable "account_tier" {
  description = "tier da storage account na Azure"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "tipo de replicacao de dados da storage account"
  type        = string
  default     = "LRS"
  sensitive   = true
}