def test_template(template: Template):
    # Assert ECS Fargate Task Definition exists
    template.resource_count_is("AWS::ECS::TaskDefinition", 1)

    # Assert IAM Roles exist
    template.resource_count_is("AWS::IAM::Role", 2)

    # Assert SSM Session Manager permissions in task role
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Action": "ssmmessages:Send",
                "Effect": "Allow",
                "Resource": "*"
            })
        }
    })

    # Assert ECR and CloudWatch Logs permissions in execution role
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Action": [
                    "ecr:GetAuthorizationToken",
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:BatchGetImage",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Effect": "Allow",
                "Resource": "*"
            })
        }
    })

    # Assert container definition with NGINX image and port 80
    template.has_resource_properties("AWS::ECS::TaskDefinition", {
        "ContainerDefinitions": Match.array_with({
            "Image": "nginx:latest",
            "PortMappings": Match.array_with({
                "ContainerPort": 80
            })
        })
    })

    # Assert CloudWatch Logs integration
    template.has_resource_properties("AWS::ECS::TaskDefinition", {
        "LogConfiguration": {
            "LogDriver": "awslogs",
            "Options": {
                "awslogs-group": Match.string_like_regexp(".*"),
                "awslogs-region": Match.string_like_regexp(".*")
            }
        }
    })

    # Assert CloudWatch Log Group with 7-day retention
    template.resource_count_is("AWS::Logs::LogGroup", 1)
    template.has_resource_properties("AWS::Logs::LogGroup", {
        "RetentionInDays": 7
    })