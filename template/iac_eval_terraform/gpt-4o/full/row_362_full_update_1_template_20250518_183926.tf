To fulfill the business need, we will create an AWS Lightsail instance using the WordPress blueprint. This setup will automatically configure a WordPress installation on the instance, allowing for quick deployment of a WordPress site. We will define the necessary resources, including the Lightsail instance with the appropriate blueprint, and ensure that the configuration is deployable in a specified AWS region. The configuration will include a provider setup for AWS and specify the instance plan and region.

<iac_template>

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_lightsail_instance" "wordpress_instance" {
  name              = "wordpress-instance"
  availability_zone = "us-west-2a"
  blueprint_id      = "wordpress"
  bundle_id         = "medium_2_0"

  tags = {
    Name = "WordPressInstance"
  }
}

output "instance_public_ip" {
  value = aws_lightsail_instance.wordpress_instance.public_ip_address
}
```

</iac_template>

This Terraform configuration will create a Lightsail instance in the `us-west-2` region using the WordPress blueprint. The instance will be of the `medium_2_0` bundle size, which is suitable for small to medium-sized WordPress sites. The public IP address of the instance will be outputted after deployment, allowing you to access the WordPress site.