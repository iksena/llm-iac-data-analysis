resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true
    tags =  merge(var.standard_tags, {
      "Name" = "${var.project_name}-${var.environment}-vpc"
    }) 
 }
resource "aws_subnet" "terraform_public_subnet_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_a_cidr
    availability_zone = "us-east-1a"
    tags = merge(var.standard_tags, {
      "Name" = "${var.project_name}-${var.environment}-public-subnet-a"
    })
}
resource "aws_subnet" "terraform_public_subnet_b" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_b_cidr
    availability_zone = "us-east-1b"
    tags = merge(var.standard_tags, {
      "Name" = "${var.project_name}-${var.environment}-public-subnet-b"
    })
}  
resource "aws_internet_gateway" "terraform_ig" {
    vpc_id = aws_vpc.main.id
    tags = merge(var.standard_tags, {
      "Name" = "${var.project_name}-${var.environment}-internet-gateway"
    })
    }   
resource "aws_route_table" "terraform_public_route_a"{
    vpc_id = aws_vpc.main.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_ig.id
    }
    route {
    cidr_block = var.public_subnet_a_cidr
    gateway_id = "local"
    }
    route {
    cidr_block = var.public_subnet_b_cidr
    gateway_id = "local"
    }                
    tags = merge(var.standard_tags, {
      Name = "${var.project_name}-${var.environment}-route-a"
    })
}
resource "aws_route_table" "terraform_public_route_b" {
    vpc_id = aws_vpc.main.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_ig.id
    }
    route {
    cidr_block = var.public_subnet_a_cidr
    gateway_id = "local"
    }
    route {
    cidr_block = var.public_subnet_b_cidr
    gateway_id = "local"
    }                
    tags = merge(var.standard_tags, {
      Name = "${var.project_name}-${var.environment}-route-b"
    })
}
resource "aws_route_table_association" "terraform_route_association_a"{
    subnet_id      = aws_subnet.terraform_public_subnet_a.id
    route_table_id = aws_route_table.terraform_public_route_a.id
}
resource "aws_route_table_association" "terraform_route_association_b"{
    subnet_id      = aws_subnet.terraform_public_subnet_b.id
    route_table_id = aws_route_table.terraform_public_route_b.id
}
#End of public subnet components

#Private Subnet
resource "aws_subnet" "terraform_private_subnet_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_a_cidr
    availability_zone = "us-east-1a"
    tags = merge(var.standard_tags, {
      Name = "${var.project_name}-${var.environment}-private-subnet-a"
    })
}
resource "aws_subnet" "terraform_private_subnet_b" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_b_cidr
    availability_zone = "us-east-1b"
    tags = merge(var.standard_tags, {
      Name = "${var.project_name}-${var.environment}-private-subnet-b"
    })
}
#Private Subnet components
#Creation of NatGateway  
resource "aws_eip" "nat_elastic_ip" {
    domain                    = "vpc"
    tags = merge(var.standard_tags, {
      Name = "${var.project_name}-${var.environment}-nat-elastic-ip"
    })  
}

resource "aws_nat_gateway" "terraform_nat_gateway" {
    allocation_id = aws_eip.nat_elastic_ip.id
    subnet_id     = aws_subnet.terraform_public_subnet_a.id
    depends_on = [aws_internet_gateway.terraform_ig]
    tags = merge(var.standard_tags, {
      Name = "${var.project_name}-${var.environment}-nat-gateway"
    })
    }

resource "aws_route_table" "terraform_private_route_a" {
    vpc_id = aws_vpc.main.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.terraform_nat_gateway.id
    }
    route {
    cidr_block = var.private_subnet_a_cidr
    gateway_id = "local"
    }
    route {
    cidr_block = var.private_subnet_b_cidr
    gateway_id = "local"
    }    
    tags = merge(var.standard_tags, {
      Name = "${var.project_name}-${var.environment}-private-route-a"
    })
}
resource "aws_route_table" "terraform_private_route_b" {
    vpc_id = aws_vpc.main.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.terraform_nat_gateway.id
    }
    route {
    cidr_block = var.private_subnet_a_cidr
    gateway_id = "local"
    }
    route {
    cidr_block = var.private_subnet_b_cidr
    gateway_id = "local"
    }        
    tags = merge(var.standard_tags, {
      Name = "${var.project_name}-${var.environment}-private-route-b"
    })
}
resource "aws_route_table_association" "terraform_nat_route_association_a"{
    subnet_id      = aws_subnet.terraform_private_subnet_a.id
    route_table_id = aws_route_table.terraform_private_route_a.id
}
resource "aws_route_table_association" "terraform_nat_route_association_b"{
    subnet_id      = aws_subnet.terraform_private_subnet_b.id
    route_table_id = aws_route_table.terraform_private_route_b.id
}

