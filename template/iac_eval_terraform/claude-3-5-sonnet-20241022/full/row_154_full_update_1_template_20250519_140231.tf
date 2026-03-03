I'll help you create a Terraform configuration to deploy an AWS Lambda Layer Version using a ZIP file. This configuration will:

1. Set up the AWS provider
2. Create a Lambda Layer Version from a local ZIP file named "lambda_layer_payload.zip"
3. Include necessary configuration parameters like compatible runtimes and description

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration:
1. Sets up the AWS provider in the us-east-1 region
2. Creates a Lambda Layer Version resource that:
   - Uses a local file named "lambda_layer_payload.zip" as the layer content
   - Names the layer "example_lambda_layer"
   - Includes a description
   - Specifies compatible runtimes (Python 3.8 and 3.9)
   - Specifies compatible architecture (x86_64)
3. Provides outputs for the Layer ARN and Version number

Note: Make sure that:
1. The "lambda_layer_payload.zip" file exists in the same directory as your Terraform configuration
2. The ZIP file follows AWS Lambda Layer structure requirements
3. You have appropriate AWS credentials configured to create Lambda Layer resources

The configuration is ready to be deployed using standard Terraform commands (terraform init, terraform plan, terraform apply).