variable "service_code" {
  description = "Code of the service. Available service codes can be fetched using the DescribeServices pricing API call."
  type        = string

  validation {
    condition     = length(var.service_code) > 0
    error_message = "data_aws_pricing_product, service_code must not be empty."
  }
}

variable "filters" {
  description = "List of filters. Passed directly to the API (see GetProducts API reference). These filters must describe a single product, this resource will fail if more than one product is returned by the API."
  type = list(object({
    field = string
    value = string
  }))

  validation {
    condition     = length(var.filters) > 0
    error_message = "data_aws_pricing_product, filters must contain at least one filter."
  }

  validation {
    condition = alltrue([
      for filter in var.filters : length(filter.field) > 0
    ])
    error_message = "data_aws_pricing_product, filters field must not be empty."
  }

  validation {
    condition = alltrue([
      for filter in var.filters : length(filter.value) > 0
    ])
    error_message = "data_aws_pricing_product, filters value must not be empty."
  }
}