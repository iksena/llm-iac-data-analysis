resource "aws_internet_gateway" "weasel_crm_gw" {
  vpc_id = aws_vpc.weasel_crm_vpc.id
  tags   = var.tags
}