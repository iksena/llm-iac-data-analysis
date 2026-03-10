# ── aws_vpc_for_microsoft_ad_p1.tf ────────────────────────────────────
# Create a VPC for Microsoft AD via the 'aws' provider

# Get availability zones to for subnet deployments
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Create default tennacy VPC with DNS hostname and resolution support using RFC 1918 /24 subnet mask
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

# Create Private subnet in 1st available AZ with the first /27 subnet mask of the VPC CIDR
resource "aws_subnet" "private_subnet1" {
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 3, 0)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id
}

# Create Private subnet in 2nd available AZ with the second /27 subnet mask of the VPC CIDR
resource "aws_subnet" "private_subnet2" {
  availability_zone       = data.aws_availability_zones.available.names[1]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 3, 1)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id
}

# Create AWS Managed Microsoft AD Enterpise Edition with a domain name of corp.example.com and NETBios name of CORP
resource "aws_directory_service_directory" "main" {
  desired_number_of_domain_controllers = 2
  edition                              = "Enterprise"
  enable_sso                           = false
  name                                 = "corp.example.com"
  password                             = "P@ssw0rd"
  short_name                           = "CORP"
  type                                 = "MicrosoftAD"
  vpc_settings {
    vpc_id     = aws_vpc.main.id
    subnet_ids = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
  }
}


# ── aws_vpc_for_microsoft_ad_p2.tf ────────────────────────────────────
# Terraform code to create a VPC for Microsoft AD via the 'aws' provider

# Get availability zones to for subnet deployments
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Create default tennacy VPC with DNS hostname and resolution support using RFC 1918 /24 subnet mask
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

# Create Private subnet in 1st available AZ with the first /27 subnet mask of the VPC CIDR
resource "aws_subnet" "private_subnet1" {
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 3, 0)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id
}

# Create Private subnet in 2nd available AZ with the second /27 subnet mask of the VPC CIDR
resource "aws_subnet" "private_subnet2" {
  availability_zone       = data.aws_availability_zones.available.names[1]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 3, 1)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id
}

# Create AWS Managed Microsoft AD Enterpise Edition with a domain name of corp.example.com and NETBios name of CORP
resource "aws_directory_service_directory" "main" {
  desired_number_of_domain_controllers = 2
  edition                              = "Enterprise"
  enable_sso                           = false
  name                                 = "corp.example.com"
  password                             = "P@ssw0rd"
  short_name                           = "CORP"
  type                                 = "MicrosoftAD"
  vpc_settings {
    vpc_id     = aws_vpc.main.id
    subnet_ids = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
  }
}


# ── aws_vpc_for_rds_sql_server_p1.tf ────────────────────────────────────
# Create a VPC for RDS SQL Server via the 'aws' provider

data "aws_partition" "main" {}

# Get availability zones to for subnet deployments
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Create default tennacy VPC with DNS hostname and resolution support using RFC 1918 /24 subnet mask
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

# Create Private subnet in 1st available AZ with the first /27 subnet mask of the VPC CIDR
resource "aws_subnet" "private_subnet1" {
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 3, 0)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id
}

# Create Private subnet in 2nd available AZ with the second /27 subnet mask of the VPC CIDR
resource "aws_subnet" "private_subnet2" {
  availability_zone       = data.aws_availability_zones.available.names[1]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 3, 1)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id
}

# Create Subnet Group for RDS Database Instance
resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
}

locals {
  rds_ports = [
    {
      from_port   = "1433"
      to_port     = "1433"
      description = "SQL"
      protocol    = "TCP"
      cidr_blocks = [aws_vpc.main.cidr_block]
    }
  ]
}

# Create Security Group for RDS Database Instance allowing TCP 1433 inbound from the VPC CIDR and all traffic outbound
resource "aws_security_group" "sg" {
  name        = "RDS-Security-Group"
  description = "RDS-Security-Group"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.rds_ports
    iterator = ports
    content {
      description = ports.value.description
      from_port   = ports.value.from_port
      to_port     = ports.value.to_port
      protocol    = ports.value.protocol
      cidr_blocks = ports.value.cidr_blocks
    }
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Get KMS Key ID of AWS provided KMS key for RDS database encryption
data "aws_kms_key" "by_id" {
  key_id = "alias/aws/rds"
}

# Assume role IAM Policy for RDS enhanced monitoring
data "aws_iam_policy_document" "rds_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

# IAM Role for RDS enhanced monitoring
resource "aws_iam_role" "rds_role" {
  name               = "RDS-Enhanced-Monitoring-Role"
  assume_role_policy = data.aws_iam_policy_document.rds_assume_role_policy.json
  managed_policy_arns = [
    "arn:${data.aws_partition.main.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  ]
}

# Create Amazon for RDS SQL Server Standard Edition single az instance with 20 GiB GP3 storage
resource "aws_db_instance" "rds" {
  allocated_storage                     = 20
  auto_minor_version_upgrade            = true
  apply_immediately                     = true
  backup_retention_period               = 5
  db_subnet_group_name                  = aws_db_subnet_group.rds.id
  delete_automated_backups              = true
  deletion_protection                   = true
  enabled_cloudwatch_logs_exports       = ["agent", "error"]
  engine                                = "sqlserver-se"
  engine_version                        = "15.00.4198.2.v1"
  identifier                            = "rds"
  instance_class                        = "db.t3.xlarge"
  kms_key_id                            = data.aws_kms_key.by_id.arn
  license_model                         = "license-included"
  manage_master_user_password           = true
  monitoring_interval                   = 5
  monitoring_role_arn                   = aws_iam_role.rds_role.arn
  multi_az                              = true
  performance_insights_enabled          = true
  performance_insights_kms_key_id       = data.aws_kms_key.by_id.arn
  performance_insights_retention_period = 7
  port                                  = "1433"
  publicly_accessible                   = false
  skip_final_snapshot                   = true
  storage_encrypted                     = true
  storage_type                          = "gp3"
  vpc_security_group_ids                = [aws_security_group.sg.id]
  username                              = "admin"
  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}


# ── aws_vpc_for_rds_sql_server_p2.tf ────────────────────────────────────
# Terraform code to create a VPC for RDS SQL Server via the 'aws' provider

data "aws_partition" "main" {}

# Get availability zones to for subnet deployments
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Create default tennacy VPC with DNS hostname and resolution support using RFC 1918 /24 subnet mask
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

# Create Private subnet in 1st available AZ with the first /27 subnet mask of the VPC CIDR
resource "aws_subnet" "private_subnet1" {
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 3, 0)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id
}

# Create Private subnet in 2nd available AZ with the second /27 subnet mask of the VPC CIDR
resource "aws_subnet" "private_subnet2" {
  availability_zone       = data.aws_availability_zones.available.names[1]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 3, 1)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id
}

# Create Subnet Group for RDS Database Instance
resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
}

locals {
  rds_ports = [
    {
      from_port   = "1433"
      to_port     = "1433"
      description = "SQL"
      protocol    = "TCP"
      cidr_blocks = [aws_vpc.main.cidr_block]
    }
  ]
}

# Create Security Group for RDS Database Instance allowing TCP 1433 inbound from the VPC CIDR and all traffic outbound
resource "aws_security_group" "sg" {
  name        = "RDS-Security-Group"
  description = "RDS-Security-Group"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.rds_ports
    iterator = ports
    content {
      description = ports.value.description
      from_port   = ports.value.from_port
      to_port     = ports.value.to_port
      protocol    = ports.value.protocol
      cidr_blocks = ports.value.cidr_blocks
    }
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Get KMS Key ID of AWS provided KMS key for RDS database encryption
data "aws_kms_key" "by_id" {
  key_id = "alias/aws/rds"
}

# Assume role IAM Policy for RDS enhanced monitoring
data "aws_iam_policy_document" "rds_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

# IAM Role for RDS enhanced monitoring
resource "aws_iam_role" "rds_role" {
  name               = "RDS-Enhanced-Monitoring-Role"
  assume_role_policy = data.aws_iam_policy_document.rds_assume_role_policy.json
  managed_policy_arns = [
    "arn:${data.aws_partition.main.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  ]
}

# Create Amazon for RDS SQL Server Standard Edition single az instance with 20 GiB GP3 storage
resource "aws_db_instance" "rds" {
  allocated_storage                     = 20
  auto_minor_version_upgrade            = true
  apply_immediately                     = true
  backup_retention_period               = 5
  db_subnet_group_name                  = aws_db_subnet_group.rds.id
  delete_automated_backups              = true
  deletion_protection                   = true
  enabled_cloudwatch_logs_exports       = ["agent", "error"]
  engine                                = "sqlserver-se"
  engine_version                        = "15.00.4198.2.v1"
  identifier                            = "rds"
  instance_class                        = "db.t3.xlarge"
  kms_key_id                            = data.aws_kms_key.by_id.arn
  license_model                         = "license-included"
  manage_master_user_password           = true
  monitoring_interval                   = 5
  monitoring_role_arn                   = aws_iam_role.rds_role.arn
  multi_az                              = true
  performance_insights_enabled          = true
  performance_insights_kms_key_id       = data.aws_kms_key.by_id.arn
  performance_insights_retention_period = 7
  port                                  = "1433"
  publicly_accessible                   = false
  skip_final_snapshot                   = true
  storage_encrypted                     = true
  storage_type                          = "gp3"
  vpc_security_group_ids                = [aws_security_group.sg.id]
  username                              = "admin"
  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}


# ── aws_vpc_with_route53_resolver_p1.tf ────────────────────────────────────
# Create a VPC with a Route53 Resolver via the 'aws' provider

# Get availability zones to for subnet deployments
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Create default tennacy VPC with DNS hostname and resolution support using RFC 1918 /24 subnet mask
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

# Create Private subnet in 1st available AZ with the first /27 subnet mask of the VPC CIDR
resource "aws_subnet" "private_subnet1" {
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 3, 0)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id
}

# Create Private subnet in 2nd available AZ with the second /27 subnet mask of the VPC CIDR
resource "aws_subnet" "private_subnet2" {
  availability_zone       = data.aws_availability_zones.available.names[1]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 3, 1)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id
}

locals {
  r53_inbound_ports = [
    {
      from_port   = 53
      to_port     = 53
      description = "DNS"
      protocol    = "TCP"
      cidr_blocks = [aws_vpc.main.cidr_block]
    },
    {
      from_port   = 53
      to_port     = 53
      description = "DNS"
      protocol    = "UDP"
      cidr_blocks = [aws_vpc.main.cidr_block]
    }
  ]
}

locals {
  r53_outbound_ports = [
    {
      from_port   = 53
      to_port     = 53
      description = "DNS"
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 53
      to_port     = 53
      description = "DNS"
      protocol    = "UDP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# Create Security Group allowing TCP and UDP ports inbound and outbound. Outbound is allow to all IP space and inbound is restricted  to the VPC CIDR.
resource "aws_security_group" "sg" {
  name        = "R53-Security-Group"
  description = "R53-Security-Group"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.r53_inbound_ports
    iterator = ports
    content {
      description = ports.value.description
      from_port   = ports.value.from_port
      to_port     = ports.value.to_port
      protocol    = ports.value.protocol
      cidr_blocks = ports.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = local.r53_outbound_ports
    iterator = ports
    content {
      description = ports.value.description
      from_port   = ports.value.from_port
      to_port     = ports.value.to_port
      protocol    = ports.value.protocol
      cidr_blocks = ports.value.cidr_blocks
    }
  }
}

# Create R53 Outbound Resolver with auto-assigned IPs.
resource "aws_route53_resolver_endpoint" "r53_outbound_resolver" {
  name               = "R53-Outbound-Resolver"
  direction          = "OUTBOUND"
  security_group_ids = [aws_security_group.sg.id]
  ip_address {
    subnet_id = aws_subnet.private_subnet1.id
  }
  ip_address {
    subnet_id = aws_subnet.private_subnet2.id
  }
}

# Create R53 Inbound Resolver with auto-assigned IPs.
resource "aws_route53_resolver_endpoint" "r53_inbound_resolver" {
  name               = "R53-Inbound-Resolver"
  direction          = "INBOUND"
  security_group_ids = [aws_security_group.sg.id]
  ip_address {
    subnet_id = aws_subnet.private_subnet1.id
  }
  ip_address {
    subnet_id = aws_subnet.private_subnet2.id
  }
}

# Create R53 Forward rule for aws.amazon.com targeting 10.0.0.10 associated with R53RInbound
resource "aws_route53_resolver_rule" "r53_outbound_resolver_rule" {
  domain_name          = "aws.amazon.com"
  name                 = "R53-Rule-Test"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.r53_outbound_resolver.id
  target_ip {
    ip = "10.0.0.10"
  }
}

# Associate the R53 Rule with the VPC
resource "aws_route53_resolver_rule_association" "r53_outbound_resolver_rule_association" {
  resolver_rule_id = aws_route53_resolver_rule.r53_outbound_resolver_rule.id
  vpc_id           = aws_vpc.main.id
}


# ── aws_vpc_with_route53_resolver_p2.tf ────────────────────────────────────
# Terraform code to create a VPC with a Route53 Resolver via the 'aws' provider

# Get availability zones to for subnet deployments
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Create default tennacy VPC with DNS hostname and resolution support using RFC 1918 /24 subnet mask
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

# Create Private subnet in 1st available AZ with the first /27 subnet mask of the VPC CIDR
resource "aws_subnet" "private_subnet1" {
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 3, 0)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id
}

# Create Private subnet in 2nd available AZ with the second /27 subnet mask of the VPC CIDR
resource "aws_subnet" "private_subnet2" {
  availability_zone       = data.aws_availability_zones.available.names[1]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 3, 1)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id
}

locals {
  r53_inbound_ports = [
    {
      from_port   = 53
      to_port     = 53
      description = "DNS"
      protocol    = "TCP"
      cidr_blocks = [aws_vpc.main.cidr_block]
    },
    {
      from_port   = 53
      to_port     = 53
      description = "DNS"
      protocol    = "UDP"
      cidr_blocks = [aws_vpc.main.cidr_block]
    }
  ]
}

locals {
  r53_outbound_ports = [
    {
      from_port   = 53
      to_port     = 53
      description = "DNS"
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 53
      to_port     = 53
      description = "DNS"
      protocol    = "UDP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# Create Security Group allowing TCP and UDP ports inbound and outbound. Outbound is allow to all IP space and inbound is restricted  to the VPC CIDR.
resource "aws_security_group" "sg" {
  name        = "R53-Security-Group"
  description = "R53-Security-Group"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.r53_inbound_ports
    iterator = ports
    content {
      description = ports.value.description
      from_port   = ports.value.from_port
      to_port     = ports.value.to_port
      protocol    = ports.value.protocol
      cidr_blocks = ports.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = local.r53_outbound_ports
    iterator = ports
    content {
      description = ports.value.description
      from_port   = ports.value.from_port
      to_port     = ports.value.to_port
      protocol    = ports.value.protocol
      cidr_blocks = ports.value.cidr_blocks
    }
  }
}

# Create R53 Outbound Resolver with auto-assigned IPs.
resource "aws_route53_resolver_endpoint" "r53_outbound_resolver" {
  name               = "R53-Outbound-Resolver"
  direction          = "OUTBOUND"
  security_group_ids = [aws_security_group.sg.id]
  ip_address {
    subnet_id = aws_subnet.private_subnet1.id
  }
  ip_address {
    subnet_id = aws_subnet.private_subnet2.id
  }
}

# Create R53 Inbound Resolver with auto-assigned IPs.
resource "aws_route53_resolver_endpoint" "r53_inbound_resolver" {
  name               = "R53-Inbound-Resolver"
  direction          = "INBOUND"
  security_group_ids = [aws_security_group.sg.id]
  ip_address {
    subnet_id = aws_subnet.private_subnet1.id
  }
  ip_address {
    subnet_id = aws_subnet.private_subnet2.id
  }
}

# Create R53 Forward rule for aws.amazon.com targeting 10.0.0.10 associated with R53RInbound
resource "aws_route53_resolver_rule" "r53_outbound_resolver_rule" {
  domain_name          = "aws.amazon.com"
  name                 = "R53-Rule-Test"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.r53_outbound_resolver.id
  target_ip {
    ip = "10.0.0.10"
  }
}

# Associate the R53 Rule with the VPC
resource "aws_route53_resolver_rule_association" "r53_outbound_resolver_rule_association" {
  resolver_rule_id = aws_route53_resolver_rule.r53_outbound_resolver_rule.id
  vpc_id           = aws_vpc.main.id
}
