To create a custom DAX (DynamoDB Accelerator) parameter group using Terraform, we will define a Terraform configuration that includes the AWS provider, a DAX parameter group resource, and any necessary IAM roles. The DAX parameter group will allow you to customize the settings for your DAX cluster, such as cache TTLs and other performance-related parameters.

The configuration will include:
- AWS provider configuration to specify the region.
- A DAX parameter group resource with custom parameters.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_dax_parameter_group" "custom_dax_parameter_group" {
  name        = "custom-dax-parameter-group"
  description = "Custom DAX parameter group for performance tuning"

  parameter {
    name  = "query-ttl-millis"
    value = "60000"
  }

  parameter {
    name  = "record-ttl-millis"
    value = "300000"
  }

  parameter {
    name  = "max-cache-memory-per-node-mb"
    value = "2048"
  }
}
```
</iac_template>

This configuration sets up a custom DAX parameter group with specific parameters for query TTL, record TTL, and maximum cache memory per node. You can adjust these parameters based on your specific performance requirements.