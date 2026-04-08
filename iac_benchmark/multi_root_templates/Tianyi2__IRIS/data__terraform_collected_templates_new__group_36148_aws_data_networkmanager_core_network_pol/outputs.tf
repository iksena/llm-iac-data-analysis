output "json" {
  description = "Standard JSON policy document rendered based on the arguments above"
  value       = data.aws_networkmanager_core_network_policy_document.this.json
}