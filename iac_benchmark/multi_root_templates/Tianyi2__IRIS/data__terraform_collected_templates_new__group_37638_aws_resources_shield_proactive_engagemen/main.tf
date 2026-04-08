resource "aws_shield_proactive_engagement" "this" {
  enabled = var.enabled

  dynamic "emergency_contact" {
    for_each = var.emergency_contact
    content {
      contact_notes = emergency_contact.value.contact_notes
      email_address = emergency_contact.value.email_address
      phone_number  = emergency_contact.value.phone_number
    }
  }
}