To create a CloudWatch Metric Alarm resource using Terraform, we will define a configuration that sets up an AWS CloudWatch alarm. This alarm will monitor a specific metric and trigger an action when the metric breaches a specified threshold. We will use the AWS provider to interact with AWS services. The configuration will include the necessary IAM roles and policies to allow CloudWatch to perform actions on our behalf. We will also specify a default region for the AWS provider.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"

  alarm_description   = "This alarm triggers if CPU utilization exceeds 80% for 10 minutes."
  alarm_actions       = [] # Add ARN of SNS topic or other actions here
  ok_actions          = [] # Add ARN of SNS topic or other actions here
  insufficient_data_actions = [] # Add ARN of SNS topic or other actions here

  dimensions = {
    InstanceId = "i-1234567890abcdef0" # Replace with your EC2 instance ID
  }
}
```
</iac_template>

This configuration sets up a CloudWatch alarm named "HighCPUUtilization" that monitors the average CPU utilization of a specific EC2 instance. The alarm triggers if the CPU utilization exceeds 80% for two consecutive 5-minute periods (10 minutes total). You can specify actions to take when the alarm state changes by adding ARNs of SNS topics or other AWS resources to the `alarm_actions`, `ok_actions`, and `insufficient_data_actions` lists. Make sure to replace the `InstanceId` with the actual ID of the EC2 instance you want to monitor.