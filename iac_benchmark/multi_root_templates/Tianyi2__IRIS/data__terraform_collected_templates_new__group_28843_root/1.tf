terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  access_key = "test"
  secret_key = "test"
  region     = "us-east-1"

  # LocalStack endpoint
  endpoints {
    iam = "http://localhost:4566"
    ec2 = "http://localhost:4566"

  }

  # Hindari validasi kredensial AWS
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

resource "aws_iam_user" "example" {
  name = "idong-user"
}


resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name= "main"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"  
  map_public_ip_on_launch=true
  tags = {
    name = "prod"
  }
}

# 5 buat  route table association
resource "aws_route_table_association" "a" {
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

# 6 BUAT SECURITY GROUP

resource "aws_security_group" "allow_tls" {
  name        = "allow_web_traffic"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "boleh_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "HTTPS"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

}

resource "aws_vpc_security_group_ingress_rule" "all00w_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "HTTP"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allowed_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "SSH"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
   cidr_ipv6        = "::/0" # Used '::/0' to allow from anywhere over IPv6
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



#8 membuat elastic ip untuk network int di step  7

resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_instance.web-server.id
  depends_on                = [aws_internet_gateway.gw]
}

#9 buat websever ubuntu or bebas dan install apace 
resource "aws_instance" "web-server" {
    ami = "ami-12345678"
    instance_type = "t2.micro"
    tags = {
        Name = "hallo"
    } 

    
    user_data  = <<-EOF
                  #!/bin/bash
                  sudo apt update -y
                  sudo apt install apache2 -y
                  sudo systemctl start apache2
                  sudo bash -c 'echo webserver pertama gw > /var/www/html/index.html'
                  EOF
          

}

output "vpc_id" {
  description = "ID dari VPC yang dibuat"
  value       = aws_vpc.myvpc.id
}

output "subnet_id" {
  description = "ID dari subnet utama"
  value       = aws_subnet.subnet-1.id
}

output "security_group_id" {
  description = "ID dari Security Group"
  value       = aws_security_group.allow_tls.id
}

output "instance_id" {
  description = "ID instance EC2 web server"
  value       = aws_instance.web-server.id
}

output "instance_private_ip" {
  description = "Private IP web server"
  value       = aws_instance.web-server.private_ip
}

output "instance_public_ip" {
  description = "Elastic IP (Public) dari instance"
  value       = aws_eip.one.public_ip
}