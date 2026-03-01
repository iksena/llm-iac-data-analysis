I'll help you create a Terraform configuration to set up an Amazon Neptune cluster with custom parameter groups. This configuration will:

1. Create a Neptune cluster parameter group with custom settings
2. Create a Neptune instance parameter group with custom settings
3. Set up a Neptune cluster
4. Create a Neptune instance within the cluster
5. Configure necessary security groups
6. Set up required IAM roles

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC (Neptune requires a VPC)
resource "aws_vpc" "neptune_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "neptune-vpc"
  }
}

# Create subnet group
resource "aws_subnet" "neptune_subnet_1" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "neptune-subnet-1"
  }
}

resource "aws_subnet" "neptune_subnet_2" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "neptune-subnet-2"
  }
}

resource "aws_db_subnet_group" "neptune_subnet_group" {
  name       = "neptune-subnet-group"
  subnet_ids = [aws_subnet.neptune_subnet_1.id, aws_subnet.neptune_subnet_2.id]

  tags = {
    Name = "Neptune DB subnet group"
  }
}

# Create security group
resource "aws_security_group" "neptune_sg" {
  name        = "neptune-security-group"
  description = "Security group for Neptune cluster"
  vpc_id      = aws_vpc.neptune_vpc.id

  ingress {
    from_port   = 8182
    to_port     = 8182
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Neptune cluster parameter group
resource "aws_neptune_cluster_parameter_group" "example" {
  family      = "neptune1"
  name        = "neptune-cluster-parameter-group"
  description = "Neptune cluster parameter group"

  parameter {
    name  = "neptune_query_timeout"
    value = "120000"
  }
}

# Create Neptune instance parameter group
resource "aws_neptune_parameter_group" "example" {
  family      = "neptune1"
  name        = "neptune-parameter-group"
  description = "Neptune instance parameter group"

  parameter {
    name  = "neptune_query_timeout"
    value = "120000"
  }
}

# Create Neptune cluster
resource "aws_neptune_cluster" "default" {
  cluster_identifier                  = "neptune-cluster-demo"
  engine                             = "neptune"
  backup_retention_period            = 5
  preferred_backup_window            = "07:00-09:00"
  skip_final_snapshot                = true
  vpc_security_group_ids            = [aws_security_group.neptune_sg.id]
  neptune_cluster_parameter_group_name = aws_neptune_cluster_parameter_group.example.name
  db_subnet_group_name              = aws_db_subnet_group.neptune_subnet_group.name
}

# Create Neptune instance
resource "aws_neptune_cluster_instance" "example" {
  cluster_identifier           = aws_neptune_cluster.default.id
  engine                      = "neptune"
  instance_class              = "db.r5.large"
  neptune_parameter_group_name = aws_neptune_parameter_group.example.name

  tags = {
    Name = "neptune-instance"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "neptune_igw" {
  vpc_id = aws_vpc.neptune_vpc.id

  tags = {
    Name = "neptune-igw"
  }
}

# Create Route Table
resource "aws_route_table" "neptune_route_table" {
  vpc_id = aws_vpc.neptune_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.neptune_igw.id
  }

  tags = {
    Name = "neptune-route-table"
  }
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.neptune_subnet_1.id
  route_table_id = aws_route_table.neptune_route_table.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.neptune_subnet_2.id
  route_table_id = aws_route_table.neptune_route_table.id
}
</iac_template>

This Terraform configuration creates:

1. A VPC with two subnets in different availability zones
2. A subnet group for Neptune
3. A security group allowing access to Neptune's default port (8182)
4. A Neptune cluster parameter group with custom settings
5. A Neptune instance parameter group with custom settings
6. A Neptune cluster using the custom parameter group
7. A Neptune instance within the cluster using the custom instance parameter group
8. Necessary networking components (Internet Gateway, Route Table)

The configuration uses the following default values:
- Region: us-east-1
- Instance type: db.r5.large
- Backup retention: 5 days
- Backup window: 07:00-09:00 UTC
- VPC CIDR: 10.0.0.0/16
- Subnet CIDRs: 10.0.1.0/24 and 10.0.2.0/24

The Neptune cluster is configured with basic security settings and is placed in a VPC with proper networking setup. The parameter groups include a custom setting for query timeout as an example.

To deploy this configuration:
1. Make sure you have AWS credentials configured
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

Note: This is a basic configuration and you might want to add more security measures, tags, or custom parameters depending on your specific requirements.