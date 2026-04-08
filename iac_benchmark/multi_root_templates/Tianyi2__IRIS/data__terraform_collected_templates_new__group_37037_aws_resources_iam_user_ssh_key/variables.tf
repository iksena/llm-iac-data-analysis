variable "username" {
  description = "The name of the IAM user to associate the SSH public key with."
  type        = string

  validation {
    condition     = can(regex("^[\\w+=,.@-]+$", var.username))
    error_message = "resource_aws_iam_user_ssh_key, username must be a valid IAM user name containing only alphanumeric characters and the following: +=,.@-"
  }
}

variable "encoding" {
  description = "Specifies the public key encoding format to use in the response. To retrieve the public key in ssh-rsa format, use SSH. To retrieve the public key in PEM format, use PEM."
  type        = string

  validation {
    condition     = contains(["SSH", "PEM"], var.encoding)
    error_message = "resource_aws_iam_user_ssh_key, encoding must be either 'SSH' or 'PEM'."
  }
}

variable "public_key" {
  description = "The SSH public key. The public key must be encoded in ssh-rsa format or PEM format."
  type        = string

  validation {
    condition     = length(var.public_key) > 0
    error_message = "resource_aws_iam_user_ssh_key, public_key cannot be empty."
  }
}

variable "status" {
  description = "The status to assign to the SSH public key. Active means the key can be used for authentication with an AWS CodeCommit repository. Inactive means the key cannot be used."
  type        = string
  default     = "Active"

  validation {
    condition     = contains(["Active", "Inactive"], var.status)
    error_message = "resource_aws_iam_user_ssh_key, status must be either 'Active' or 'Inactive'."
  }
}