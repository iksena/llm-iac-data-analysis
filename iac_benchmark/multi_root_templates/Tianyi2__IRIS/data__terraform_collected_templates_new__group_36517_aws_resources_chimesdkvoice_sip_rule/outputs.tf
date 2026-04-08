output "id" {
  description = "The SIP rule ID"
  value       = aws_chimesdkvoice_sip_rule.this.id
}

output "name" {
  description = "The name of the SIP rule"
  value       = aws_chimesdkvoice_sip_rule.this.name
}

output "trigger_type" {
  description = "The type of trigger assigned to the SIP rule"
  value       = aws_chimesdkvoice_sip_rule.this.trigger_type
}

output "trigger_value" {
  description = "The trigger value for the SIP rule"
  value       = aws_chimesdkvoice_sip_rule.this.trigger_value
}

output "target_applications" {
  description = "List of SIP media applications with priority and AWS Region"
  value       = aws_chimesdkvoice_sip_rule.this.target_applications
}

output "disabled" {
  description = "Whether the SIP rule is disabled"
  value       = aws_chimesdkvoice_sip_rule.this.disabled
}