resource "aws_cloudfrontkeyvaluestore_keys_exclusive" "this" {
  key_value_store_arn = var.key_value_store_arn
  max_batch_size      = var.max_batch_size

  dynamic "resource_key_value_pair" {
    for_each = var.resource_key_value_pairs
    content {
      key   = resource_key_value_pair.value.key
      value = resource_key_value_pair.value.value
    }
  }
}