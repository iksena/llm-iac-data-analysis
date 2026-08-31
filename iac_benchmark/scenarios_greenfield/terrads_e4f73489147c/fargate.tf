resource "aws_ecs_cluster" "main" {
  name = "${local.prefix}-fargate-cluster"
  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-fargate-cluster"
    }
  )
}
