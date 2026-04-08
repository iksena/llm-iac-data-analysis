resource "aws_iot_policy_attachment" "this" {
  policy = var.policy
  target = var.target
}