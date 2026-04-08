output "id" {
  description = "Combination of attributes to create a unique ID: lb_name,instance_name."
  value       = aws_lightsail_lb_attachment.this.id
}