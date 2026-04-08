variable "region" {
    description = "The AWS region to launch the resources."
    type        = string
    default     = "us-east-1"
}

variable "db_username" {
    type = string
    description = "The username for the database using ENV variable."
}

variable "db_password" {
    type = string
    description = "The password for the database using ENV variable."
}