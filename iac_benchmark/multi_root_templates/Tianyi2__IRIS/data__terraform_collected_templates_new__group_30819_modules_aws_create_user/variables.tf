variable "user" {
  type = string
  description = "(Required) The user's name"
}

variable "force_destroy" {
  type = bool
  description = "(Optional, default false) When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed."
  default = false
}

variable "keybase_user" {
  type = string
  description = "(Required) a keybase username in the form keybase:some_person_that_exists, for use in the encrypted_secret output attribute"
}

variable "policies" {
  type = list
  description = "(Optional) Array policies document. They are a JSON formatted string. "
  default = []
}