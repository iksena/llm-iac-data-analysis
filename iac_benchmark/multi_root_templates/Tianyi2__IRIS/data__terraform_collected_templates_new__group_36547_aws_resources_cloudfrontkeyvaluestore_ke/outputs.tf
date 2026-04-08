output "total_size_in_bytes" {
  description = "Total size of the Key Value Store in bytes"
  value       = aws_cloudfrontkeyvaluestore_keys_exclusive.this.total_size_in_bytes
}