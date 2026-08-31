variable "access_key" {
    default = "unused"
}
variable "secret_key" {
    default = "unused"
}
variable "region" {
    default = "ap-northeast-1"
}
variable "availability_zones" {
    default = {
        "1" = "ap-northeast-1a"
        "2" = "ap-northeast-1c"
    }
}

variable "app_name" {
    default = "yourname" # only lowercase
}

variable "aws_vpc_cidr" {
    default = "10.100.0.0/16"
}
variable "public_subnet_cidrs" {
    default = {
        "1" = "10.100.10.0/24"
        "2" = "10.100.20.0/24"
    }
}
variable "private_subnet_cidrs" {
    default = {
        "1" = "10.100.110.0/24"
        "2" = "10.100.120.0/24"
    }
}

variable "my_public_key" {
    default  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGJe3K6rxmGoQhb/TTt8RuLFbtwb8xGk+wxFttC+mVU8lihen3ZPCDH7FY7D+7hmb099WU5Dpx1qxkFaKYllZi6j1RlNgmx2z1LHVjn0f9P5jz6JxTgIaarrNKjieUeU+JSd+xl1WyQvu5ad7WANlcwp9cBTJlxWriHNXBjuLmFkSyDHAAyNX99Ymer/2GH/DeOGzp3i71WveTNLUKecod0UWODjklcJ1VInX/kKZVkQmjNGHoQRT7u61JvWudcxY6OgoBMo56SXVhpALIuiO5oIN4aOzzWICtweiHhPc0/1ckvWIS6hPEWuUGcVg0B0FMJvgc9tDbGfDNBVC0hqLB"
}
#my_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGJe3K6rxmGoQhb/TTt8RuLFbtwb8xGk+wxFttC+mVU8lihen3ZPCDH7FY7D+7hmb099WU5Dpx1qxkFaKYllZi6j1RlNgmx2z1LHVjn0f9P5jz6JxTgIaarrNKjieUeU+JSd+xl1WyQvu5ad7WANlcwp9cBTJlxWriHNXBjuLmFkSyDHAAyNX99Ymer/2GH/DeOGzp3i71WveTNLUKecod0UWODjklcJ1VInX/kKZVkQmjNGHoQRT7u61JvWudcxY6OgoBMo56SXVhpALIuiO5oIN4aOzzWICtweiHhPc0/1ckvWIS6hPEWuUGcVg0B0FMJvgc9tDbGfDNBVC0hqLB"

variable "images" {
    default = {
        us-east-1      = "ami-1ecae776"
        us-west-2      = "ami-e7527ed7"
        us-west-1      = "ami-d114f295"
        eu-west-1      = "ami-a10897d6"
        eu-central-1   = "ami-a8221fb5"
        ap-southeast-1 = "ami-68d8e93a"
        ap-southeast-2 = "ami-fd9cecc7"
        ap-northeast-1 = "ami-cbf90ecb"
        sa-east-1      = "ami-b52890a8"
    }
}

variable "cybird_ips" {
    default = {
        "1" = "124.35.1.202/32"
        "2" = "202.228.194.1/32"
        "3" = "122.219.131.113/32"
    }
}
