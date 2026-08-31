data "aws_region" "current" {}

resource "aws_vpc_endpoint" "ecr_api" {
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.main.id
//  subnet_ids          = aws_subnet.private.*.id
  subnet_ids          = var.subnet_private_cidrs == null ? aws_subnet.public.*.id : aws_subnet.private.*.id
  security_group_ids  = [aws_security_group.ecr_endpoint.id]
  private_dns_enabled = true

  tags = merge(
    {
      "Name" = "${var.base_name}-ECR-API-Endpoint"
    },
    var.tags
  )
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.main.id
//  subnet_ids          = aws_subnet.private.*.id
  subnet_ids          = var.subnet_private_cidrs == null ? aws_subnet.public.*.id : aws_subnet.private.*.id
  security_group_ids  = [aws_security_group.ecr_endpoint.id]
  private_dns_enabled = true

  tags = merge(
    {
      "Name" = "${var.base_name}-ECR-DKR-Endpoint"
    },
    var.tags
  )
}


resource "aws_vpc_endpoint" "s3_public_subnet" {
  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = [aws_route_table.public.id]

  tags = merge(
    {
      "Name" = "${var.base_name}-S3-Endpoint-public-subnet"
    },
    var.tags
  )
}

resource "aws_vpc_endpoint" "s3_private_subnet" {
  count = var.subnet_private_cidrs == null ? 0 : 1

  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = aws_route_table.private.*.id

  tags = merge(
  {
    "Name" = "${var.base_name}-S3-Endpoint-private-subnet"
  },
  var.tags
  )
}

# com.amazonaws.Region.logs