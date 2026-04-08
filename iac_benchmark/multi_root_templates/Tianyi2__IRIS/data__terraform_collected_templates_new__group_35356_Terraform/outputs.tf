output "bucket_name" {
  value       = aws_s3_bucket.assets.bucket
  description = "Name of the S3 bucket for static assets"
}

output "s3_bucket_url" {
  value       = "https://${aws_s3_bucket.assets.bucket}.s3.amazonaws.com"
  description = "Base URL for S3 bucket assets"
}

output "innstance_public_ip" {
  value       = aws_instance.flask_app_instance.public_ip
  description = "Public IP address of the Flask app EC2 instance"
}

output "instance_public_ip" {
  value = aws_instance.flask_app_instance.id
  description = "ID of the Flask app EC2 instance"
}