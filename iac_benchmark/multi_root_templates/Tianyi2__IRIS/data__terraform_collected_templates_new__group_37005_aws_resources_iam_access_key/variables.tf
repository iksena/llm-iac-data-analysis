variable "pgp_key" {
  description = "Either a base-64 encoded PGP public key, or a keybase username in the form `keybase:some_person_that_exists`, for use in the `encrypted_secret` output attribute. If providing a base-64 encoded PGP public key, make sure to provide the \"raw\" version and not the \"armored\" one (e.g. avoid passing the `-a` option to `gpg --export`)."
  type        = string
  default     = null
}

variable "status" {
  description = "Access key status to apply. Defaults to `Active`. Valid values are `Active` and `Inactive`."
  type        = string
  default     = "Active"

  validation {
    condition     = contains(["Active", "Inactive"], var.status)
    error_message = "resource_aws_iam_access_key, status must be either 'Active' or 'Inactive'."
  }
}

variable "user" {
  description = "IAM user to associate with this access key."
  type        = string

  validation {
    condition     = length(var.user) > 0
    error_message = "resource_aws_iam_access_key, user cannot be empty."
  }
}