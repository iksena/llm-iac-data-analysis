provider "aws" {
  alias = "this"
}

resource "aws_chimesdkvoice_sip_rule" "this" {
  name          = var.name
  trigger_type  = var.trigger_type
  trigger_value = var.trigger_value

  dynamic "target_applications" {
    for_each = var.target_applications
    content {
      aws_region               = target_applications.value.aws_region
      priority                 = target_applications.value.priority
      sip_media_application_id = target_applications.value.sip_media_application_id
    }
  }

  disabled = var.disabled

  provider = aws.this
}