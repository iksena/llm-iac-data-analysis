# ---------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. Licensed under the MIT license.
# ---------------------------------------------------------------------

variable "location" {
  type        = string
  description = "Azure region where the resources will be deployed."
  default     = "swedencentral"
}

variable "base_name" {
  type        = string
  description = "Semantic base name used for generating resource names with 'durable' suffix."
  default     = "fbscprv"
}
