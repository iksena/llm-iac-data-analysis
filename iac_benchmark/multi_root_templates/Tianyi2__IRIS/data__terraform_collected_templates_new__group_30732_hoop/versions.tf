##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

terraform {
  required_version = ">= 1.3"
  # Complete with required providers for the module
  required_providers {
    hoop = {
      source  = "hoophq/hoop"
      version = "~> 0.0.18"
    }
  }
}
