To fulfill the business need, we will create a Terraform configuration that sets up a NAT Gateway in AWS. This configuration will include the creation of a VPC, a public subnet, an Elastic IP, and the NAT Gateway itself. The NAT Gateway will be associated with the specified subnet and Elastic IP allocation ID, allowing instances in private subnets to access the internet through the NAT Gateway.

The configuration will include:
- An AWS VPC to host the network resources.
- A public subnet within the VPC.
- An Elastic IP address to provide a public IP for the NAT Gateway.
- A NAT Gateway associated with the public subnet and Elastic IP.

Below is the Terraform HCL configuration for this setup:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-gateway"
  }
}
```
</iac_template>

This configuration will create a NAT Gateway with public connectivity, using an Elastic IP and associating it with a specified public subnet within a VPC. The NAT Gateway will allow instances in private subnets to access the internet securely.