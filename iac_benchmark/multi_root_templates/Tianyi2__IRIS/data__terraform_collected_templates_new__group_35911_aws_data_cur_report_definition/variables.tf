variable "report_name" {
  description = "Name of the report definition to match."
  type        = string

  validation {
    condition     = length(var.report_name) > 0
    error_message = "data_aws_cur_report_definition, report_name must not be empty."
  }
}