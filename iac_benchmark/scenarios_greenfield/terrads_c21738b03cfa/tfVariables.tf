variable "glueingestionpolicy" {
  description = "Policy IAM para o serviço de ingestão de dados no Glue"
  type        = string
}

variable "glueingestionrole" {
  description = "Role IAM para o serviço de ingestão de dados no Glue"
  type        = string
}

variable "glueJobName" {
  description = "Nome Job Glue"
  type        = string
}

variable "glueJobNameTransforma" {
  description = "Nome Job Glue"
  type        = string
}

variable "python_version" {
  description = "Versão Python do Job Glue"
  type        = string
}

variable "bucket_artefact_glue" {
  description = "Bucket S3 Armazenamento Scripts Glue"
  type        = string
}

variable "bucket_staging_lake" {
  description = "Bucket S3 Armazenamento Dados Camada Staging"
  type        = string
}

variable "bucket_bronze_lake" {
  description = "Bucket S3 Armazenamento Dados Camada Bronze"
  type        = string
}

variable "bucket_silver_lake" {
  description = "Bucket S3 Armazenamento Dados Camada Bronze"
  type        = string
}

variable "bucket_gold_lake" {
  description = "Bucket S3 Armazenamento Dados Camada Bronze"
  type        = string
}

variable "bucket_log" {
  description = "Bucket S3 Armazenamento os Logs"
  type        = string
}

variable "key_api" {
  description = "Key API Clima"
  type        = string
}

variable "Cidade_API_Clima" {
  description = "Cidade para coleta de temperatura API"
  type        = string
}

variable "schedulerColetaClima" {
  description = "Schedulaer para Coleta do Clima"
  type        = string
}

variable "keyTraduz" {
  description = "Key API Tradução Azure"
  type        = string
}
