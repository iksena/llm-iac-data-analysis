I'll help you create a Terraform configuration for a basic AWS RDS instance using gp3 storage type. This configuration will:

1. Set up an AWS provider
2. Create a security group for the RDS instance
3. Create a basic RDS instance with:
   - MySQL engine
   - gp3 storage type
   - Instance class: db.t3.micro (for cost-effectiveness)
   - 20GB storage
   - Basic security group allowing inbound MySQL traffic

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security group for RDS instance"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

# Create RDS Instance
resource "aws_db_instance" "default" {
  identifier           = "my-rds-instance"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_type        = "gp3"
  storage_encrypted   = true
  
  username            = "admin"
  password            = "password123!" # Change this in production

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  skip_final_snapshot    = true
  
  tags = {
    Name = "my-rds-instance"
  }
}

# Output the RDS endpoint
output "rds_endpoint" {
  value = aws_db_instance.default.endpoint
}
</iac_template>

This configuration creates a basic RDS instance with gp3 storage type. Note the following important points:

1. The security group allows inbound MySQL traffic (port 3306) from any IP (0.0.0.0/0). In a production environment, you should restrict this to specific IP ranges.
2. The password is hardcoded for demonstration purposes. In a production environment, you should use variables and secure storage for sensitive information.
3. skip_final_snapshot is set to true to make deletion easier. In production, you might want to set this to false.
4. The instance uses encryption by default (storage_encrypted = true).
5. The configuration outputs the RDS endpoint which you can use to connect to the database.

To make this more secure for production use, you should:
1. Use more restricted security group rules
2. Store sensitive data in variables
3. Use a stronger password
4. Consider using a larger instance class depending on your workload
5. Implement proper backup and maintenance windows
6. Place the RDS instance in a private subnet within a VPC