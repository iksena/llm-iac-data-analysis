output "result" {
  description = "Set to the product returned from the API."
  value       = data.aws_pricing_product.this.result
}