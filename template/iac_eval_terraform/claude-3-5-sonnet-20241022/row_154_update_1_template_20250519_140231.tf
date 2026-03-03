provider "aws" {
  region = "us-east-1"
}

# Create Lambda Layer Version
resource "aws_lambda_layer_version" "example_layer" {
  filename            = "lambda_layer_payload.zip"
  layer_name         = "example_lambda_layer"
  description        = "Example Lambda Layer containing custom dependencies"
  
  # Specify compatible Lambda runtimes
  compatible_runtimes = ["python3.8", "python3.9"]

  # Optional: Specify compatible architectures
  compatible_architectures = ["x86_64"]
}

# Output the Lambda Layer Version ARN
output "lambda_layer_arn" {
  description = "ARN of the created Lambda Layer Version"
  value       = aws_lambda_layer_version.example_layer.arn
}

# Output the Lambda Layer Version number
output "lambda_layer_version" {
  description = "Version number of the created Lambda Layer"
  value       = aws_lambda_layer_version.example_layer.version
}