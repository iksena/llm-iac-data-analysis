resource "aws_datapipeline_pipeline_definition" "this" {
  pipeline_id = var.pipeline_id
  region      = var.region

  dynamic "pipeline_object" {
    for_each = var.pipeline_object
    content {
      id   = pipeline_object.value.id
      name = pipeline_object.value.name

      dynamic "field" {
        for_each = pipeline_object.value.field
        content {
          key          = field.value.key
          ref_value    = field.value.ref_value
          string_value = field.value.string_value
        }
      }
    }
  }

  dynamic "parameter_object" {
    for_each = var.parameter_object
    content {
      id = parameter_object.value.id

      dynamic "attribute" {
        for_each = parameter_object.value.attribute
        content {
          key          = attribute.value.key
          string_value = attribute.value.string_value
        }
      }
    }
  }

  dynamic "parameter_value" {
    for_each = var.parameter_value
    content {
      id           = parameter_value.value.id
      string_value = parameter_value.value.string_value
    }
  }
}