variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "language" {
  description = "Programming language of the resulting code from the DAG. Defaults to PYTHON. Valid values are PYTHON and SCALA."
  type        = string
  default     = "PYTHON"

  validation {
    condition     = contains(["PYTHON", "SCALA"], var.language)
    error_message = "data_aws_glue_script, language must be either 'PYTHON' or 'SCALA'."
  }
}

variable "dag_edges" {
  description = "List of the edges in the DAG."
  type = list(object({
    source           = string
    target           = string
    target_parameter = optional(string)
  }))

  validation {
    condition     = length(var.dag_edges) > 0
    error_message = "data_aws_glue_script, dag_edges must contain at least one edge."
  }

  validation {
    condition = alltrue([
      for edge in var.dag_edges :
      edge.source != null && edge.source != "" && edge.target != null && edge.target != ""
    ])
    error_message = "data_aws_glue_script, dag_edges source and target must not be null or empty."
  }
}

variable "dag_nodes" {
  description = "List of the nodes in the DAG."
  type = list(object({
    id          = string
    node_type   = string
    line_number = optional(number)
    args = list(object({
      name  = string
      value = string
      param = optional(bool, false)
    }))
  }))

  validation {
    condition     = length(var.dag_nodes) > 0
    error_message = "data_aws_glue_script, dag_nodes must contain at least one node."
  }

  validation {
    condition = alltrue([
      for node in var.dag_nodes :
      node.id != null && node.id != "" && node.node_type != null && node.node_type != ""
    ])
    error_message = "data_aws_glue_script, dag_nodes id and node_type must not be null or empty."
  }

  validation {
    condition = alltrue([
      for node in var.dag_nodes :
      length(node.args) > 0
    ])
    error_message = "data_aws_glue_script, dag_nodes args must contain at least one argument."
  }

  validation {
    condition = alltrue([
      for node in var.dag_nodes :
      alltrue([
        for arg in node.args :
        arg.name != null && arg.name != "" && arg.value != null && arg.value != ""
      ])
    ])
    error_message = "data_aws_glue_script, dag_nodes args name and value must not be null or empty."
  }
}