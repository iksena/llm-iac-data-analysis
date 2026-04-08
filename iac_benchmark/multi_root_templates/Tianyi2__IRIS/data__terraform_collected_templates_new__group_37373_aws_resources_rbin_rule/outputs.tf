output "id" {
  description = "ID of the Rule."
  value       = aws_rbin_rule.this.id
}

output "lock_end_time" {
  description = "Date and time at which the unlock delay is set to expire. Only returned for retention rules that have been unlocked and that are still within the unlock delay period."
  value       = aws_rbin_rule.this.lock_end_time
}

output "lock_state" {
  description = "Lock state of the retention rules to list. Only retention rules with the specified lock state are returned. Valid values are locked, pending_unlock, unlocked."
  value       = aws_rbin_rule.this.lock_state
}

output "status" {
  description = "State of the retention rule. Only retention rules that are in the available state retain resources. Valid values include pending and available."
  value       = aws_rbin_rule.this.status
}