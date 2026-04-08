output "id" {
  description = "Combination of attributes to create a unique id: `lb_name`,`certificate_name`"
  value       = aws_lightsail_lb_certificate_attachment.this.id
}