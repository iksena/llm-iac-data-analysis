output "id" {
  description = "Combination of attributes separated by a `,` to create a unique id: `key_value_store_arn`,`key`"
  value       = aws_cloudfrontkeyvaluestore_key.this.id
}

output "total_size_in_bytes" {
  description = "Total size of the Key Value Store in bytes."
  value       = aws_cloudfrontkeyvaluestore_key.this.total_size_in_bytes
}