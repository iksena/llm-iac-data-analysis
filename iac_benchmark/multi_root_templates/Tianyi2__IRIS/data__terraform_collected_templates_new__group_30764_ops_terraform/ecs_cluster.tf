resource "aws_ecs_cluster" "main" {
  name = "springboot-kunlaquota-cluster"

  tags = {
    Owner: "TimS"
    Name: "tims-kunlaquota-ecs-cluster"
  }
}

