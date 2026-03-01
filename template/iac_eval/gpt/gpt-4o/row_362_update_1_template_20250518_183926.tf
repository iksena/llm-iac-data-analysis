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