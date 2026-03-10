# ── main.tf ────────────────────────────────────
resource "random_string" "container_name" {
  length  = 25
  lower   = true
  upper   = false
  special = false
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${local.default_suffix}"
  location = var.location
  
}

resource "azapi_resource" "log_analytics_workspace" {
  type      = "Microsoft.OperationalInsights/workspaces@2025-02-01"
  name      = "law-${var.container_group_name_prefix}-${random_string.container_name.result}"
  location  = var.location
  parent_id = azurerm_resource_group.example.id
  body = {
    properties = {
      sku = {
        name = "PerGB2018"
      }
      retentionInDays = 30
    }
  }
  tags = local.default_tags
}

ephemeral "azapi_resource_action" "law_shared_key" {
  action                 = "sharedKeys"
  method                 = "POST"
  resource_id            = azapi_resource.log_analytics_workspace.output.id
  type                   = "Microsoft.OperationalInsights/workspaces@2020-08-01"
  response_export_values = ["primarySharedKey", "secondarySharedKey"]
}

resource "azapi_resource" "container" {
  type      = "Microsoft.ContainerInstance/containerGroups@2023-05-01"
  name      = "${var.container_group_name_prefix}-${random_string.container_name.result}"
  location  = var.location
  parent_id = azurerm_resource_group.example.id
  body = {
    properties = {
      containers = [
        {
          name = "${var.container_name_prefix}-${random_string.container_name.result}"
          properties = {
            image = var.image
            resources = {
              requests = {
                cpu        = var.cpu_cores
                memoryInGB = var.memory_in_gb
              }
            }
            ports = [
              {
                port     = var.port
                protocol = "TCP"
              }
            ]
          }
        }
      ]
      diagnostics = {
        logAnalytics = {
          logType             = "ContainerInsights"
          workspaceId         = azapi_resource.log_analytics_workspace.output.properties.customerId
          workspaceResourceId = azapi_resource.log_analytics_workspace.output.id
        }
      }
      osType        = "Linux"
      restartPolicy = var.restart_policy
      ipAddress = {
        type = "Public"
        ports = [
          {
            port     = var.port
            protocol = "TCP"
          }
        ]
      }
    }
  }
  response_export_values = ["properties.ipAddress.ip"]
  sensitive_body = {
    properties = {
      diagnostics = {
        logAnalytics = {
          workspaceKey = ephemeral.azapi_resource_action.law_shared_key.output.secondarySharedKey
        }
      }
    }
  }
  schema_validation_enabled = false
  tags                      = local.default_tags
}

# ── variables.tf ────────────────────────────────────
variable "short_location_code" {
  description = "A short form of the location where resource are deployed, used in naming conventions."
  type        = string
  default     = "auea"
}

variable "env_code" {
  description = "Short name of the environment used for naming conventions (e.g. dev, test, prod)."
  type        = string
  validation {
    condition = contains(
      ["dev", "test", "uat", "prod"],
      var.env_code
    )
    error_message = "Err: environment should be one of dev, test or prod."
  }
  validation {
    condition     = length(var.env_code) <= 4
    error_message = "Err: environment code should be 4 characters or shorter."
  }
}

# tags are expected to be provided
variable "default_tags" {
  description = <<DESCRIPTION
Tags to be applied to resources.  Default tags are expected to be provided in local.default_tags, 
which is merged with environment specific ones in ``environments\env.terraform.tfvars``.
Most resources will simply apply the default tags like this:

```terraform
tags = local.default_tags
```

Additional tags can be provided by using a merge, for instance:

```terraform
tags = merge(
    local.default_tags,
    tomap({
      "MyExtraResourceTag" = "TheTagValue"
    })
)
```

Note you can also use the above mechanims to override or modify the default tags for an individual resource,
since only unique items in a map are retained, and later tags supplied to merge() function take precedence.
DESCRIPTION
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "australiaeast"
}

variable "container_group_name_prefix" {
  type        = string
  description = "Prefix of the container group name that's combined with a random value so name is unique in your Azure subscription."
  default     = "acigroup"
}

variable "container_name_prefix" {
  type        = string
  description = "Prefix of the container name that's combined with a random value so name is unique in your Azure subscription."
  default     = "aci"
}

variable "image" {
  type        = string
  description = "Container image to deploy. Should be of the form repoName/imagename:tag for images stored in public Docker Hub, or a fully qualified URI for other registries. Images from private registries require additional registry credentials."
  default     = "mcr.microsoft.com/azuredocs/aci-helloworld"
}

variable "port" {
  type        = number
  description = "Port to open on the container and the public IP address."
  default     = 80

  validation {
    condition     = var.port > 0 && var.port <= 65535
    error_message = "The port must be a number between 1 and 65535."
  }
}

variable "cpu_cores" {
  type        = number
  description = "The number of CPU cores to allocate to the container."
  default     = 1
}

variable "memory_in_gb" {
  type        = number
  description = "The amount of memory to allocate to the container in gigabytes."
  default     = 2
}

variable "restart_policy" {
  type        = string
  description = "The behavior of Azure runtime if container has stopped."
  default     = "Always"
  validation {
    condition     = contains(["Always", "Never", "OnFailure"], var.restart_policy)
    error_message = "The restart_policy must be one of the following: Always, Never, OnFailure."
  }
}

# ── outputs.tf ────────────────────────────────────
output "resource_group_name" {
  value = local.resource_group_name
}

output "container_ipv4_address" {
  value = azapi_resource.container.output.properties.ipAddress.ip
}

# ── locals.tf ────────────────────────────────────
locals {
  appname        = "azapi-ephemeral-demo"
  default_suffix = "${local.appname}-${var.env_code}"

  # optional computed short name
  # this assume two letters for the resource type, three for the location, and three for the environment code (= 24 chars max)
  # short_appname        = substr(replace(local.appname, "-", ""), 0, 16) 
  # default_short_suffix = "${local.short_appname}${var.env_code}"

  # add resource names here, using CAF-aligned naming conventions
  resource_group_name = "rg-${local.default_suffix}"

  # tflint-ignore: terraform_unused_declarations
  default_tags = merge(
    var.default_tags,
    tomap({
      "Environment"  = var.env_code
      "LocationCode" = var.short_location_code
    })
  )
}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_version = ">= 1.8.0"

  required_providers {
    # The root of the configuration where Terraform Apply runs should specify the maximum allowed provider version.
    # https://developer.hashicorp.com/terraform/language/providers/requirements#best-practices-for-provider-versions  
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.23"
    }
  }

}

provider "azapi" {
  enable_preflight = true
}

provider "azurerm" {
  features {}
}