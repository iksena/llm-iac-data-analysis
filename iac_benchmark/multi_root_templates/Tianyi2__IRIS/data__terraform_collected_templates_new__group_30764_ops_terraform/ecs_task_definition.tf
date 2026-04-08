
resource "aws_ecs_task_definition" "kunlaquota" {
  family                   = "springboot-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "kunlaquota"
      image = "${data.aws_ecr_repository.kunlaquota.repository_url}:0.0.1-SNAPSHOT"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      environment = [
        {
          name  = "SPRING_DATASOURCE_URL"
          value = "jdbc:postgres://${aws_db_instance.kunlaquotadb.endpoint}:5432/kunlaquota"
        },
      ]
      secrets = [
        {
          name      = "SPRING_DATASOURCE_USERNAME"
          valueFrom = aws_db_instance.kunlaquotadb.username
        },
        {
          name      = "SPRING_DATASOURCE_PASSWORD"
          valueFrom = aws_db_instance.kunlaquotadb.password
        }
      ]
    }
  ])

  tags = {
    Owner: "TimS"
    Name: "tims-kunlaquota-ecs-task-def"
  }
}

data "aws_ecr_repository" "kunlaquota" {
  name = "kunlaquota-repo"
}