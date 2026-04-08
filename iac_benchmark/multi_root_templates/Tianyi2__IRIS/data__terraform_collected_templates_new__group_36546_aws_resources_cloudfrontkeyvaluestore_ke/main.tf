resource "aws_cloudfrontkeyvaluestore_key" "this" {
  key                 = var.key
  key_value_store_arn = var.key_value_store_arn
  value               = var.value
}