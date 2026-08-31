resource "aws_nat_gateway" "weasel_crm_ngw" {
  allocation_id = aws_eip.weasel_crm_nat.id
  subnet_id     = aws_subnet.weasel_crm_public3.id
  tags          = var.tags
}

resource "aws_eip" "weasel_crm_nat" {
  domain = "vpc"
  tags   = var.tags
}