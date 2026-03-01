To create a SageMaker JupyterServer app using Terraform, we need to define a SageMaker app resource. This will involve setting up the necessary IAM roles and policies to allow the SageMaker app to function correctly. We'll also configure the app to be of type `JupyterServer`. The configuration will include setting up the AWS provider, defining the IAM roles and policies, and creating the SageMaker app resource.

Below is the Terraform HCL configuration to achieve this:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "sagemaker_execution_role" {
  name = "SageMakerExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "sagemaker_execution_policy" {
  name = "SageMakerExecutionPolicy"
  role = aws_iam_role.sagemaker_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_sagemaker_app" "jupyter_server" {
  app_name       = "MyJupyterServerApp"
  app_type       = "JupyterServer"
  domain_id      = "d-xxxxxxxxxx" # Replace with your domain ID
  user_profile_name = "my-user-profile" # Replace with your user profile name

  resource_spec {
    instance_type = "ml.t3.medium"
  }
}
```
</iac_template>

### Explanation:
- **Provider Configuration**: The AWS provider is configured to use the `us-west-2` region.
- **IAM Role and Policy**: An IAM role is created for SageMaker with a policy that allows access to S3 and CloudWatch, which are commonly needed for SageMaker operations.
- **SageMaker App**: The `aws_sagemaker_app` resource is defined to create a JupyterServer app. You need to replace `domain_id` and `user_profile_name` with your actual SageMaker domain ID and user profile name.
- **Resource Spec**: The instance type is set to `ml.t3.medium`, which is a common choice for JupyterServer instances. Adjust as needed based on your requirements.