provider "aws" {
  region = "us-east-1"
}

# Create an IAM Role for Kinesis Analytics V2 service execution
resource "aws_iam_role" "kinesisanalytics_role" {
  name = "example_kinesisanalytics_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "kinesisanalytics.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach an inline policy to the IAM role to allow CloudWatch Logs actions
resource "aws_iam_role_policy" "kinesisanalytics_policy" {
  name   = "example_kinesisanalytics_policy"
  role   = aws_iam_role.kinesisanalytics_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "*"
    }]
  })
}

# Create a basic Kinesis Data Analytics V2 Application for an Apache Flink application
resource "aws_kinesisanalyticsv2_application" "flink_app" {
  name                   = "example-flink-app"
  runtime_environment    = "FLINK-1_8"
  service_execution_role = aws_iam_role.kinesisanalytics_role.arn

  application_configuration {
    application_code_configuration {
      code_content {
        text_content = <<EOF
// Simple Apache Flink application placeholder
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

public class FlinkApp {
    public static void main(String[] args) throws Exception {
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        // Add your Flink application logic here
        env.execute("Example Flink Application");
    }
}
EOF
      }
      code_content_type = "PLAINTEXT"
    }
    # Other configurations (e.g., checkpointing, monitoring) can be added as needed.
  }

  # Optional: you can define a basic description if required.
  application_description = "Example Apache Flink application managed by Kinesis Data Analytics V2."
}