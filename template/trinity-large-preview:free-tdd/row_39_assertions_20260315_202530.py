def test_template(template: Template):
    # Assert exactly one ECR repository exists
    template.resource_count_is("AWS::ECR::Repository", 1)

    # Assert the ECR repository has a repository policy attached
    template.resource_count_is("AWS::ECR::RepositoryPolicy", 1)

    # Capture the repository name for use in the policy ARN
    repo_capture = Capture()

    # Assert the repository has the expected properties
    template.has_resource_properties("AWS::ECR::Repository", {
        "RepositoryName": Match.any_value()  # Name can be anything
    }, capture=repo_capture)

    # Assert the repository policy grants root user permissions for critical actions
    template.has_resource_properties("AWS::ECR::RepositoryPolicy", {
        "PolicyDocument": {
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": {
                            "Fn::Join": [
                                "",
                                [
                                    "arn:",
                                    { "Ref": "AWS::Partition" },
                                    ":iam::",
                                    { "Ref": "AWS::AccountId" },
                                    ":root"
                                ]
                            ]
                        }
                    },
                    "Action": [
                        "ecr:GetDownloadUrlForLayer",
                        "ecr:BatchGetImage",
                        "ecr:BatchCheckLayerAvailability",
                        "ecr:PutImage",
                        "ecr:InitiateLayerUpload",
                        "ecr:UploadLayerPart",
                        "ecr:CompleteLayerUpload",
                        "ecr:DescribeRepositories",
                        "ecr:GetRepositoryPolicy",
                        "ecr:ListImages",
                        "ecr:DeleteRepository",
                        "ecr:BatchDeleteImage",
                        "ecr:SetRepositoryPolicy",
                        "ecr:PutLifecyclePolicy"
                    ],
                    "Resource": {
                        "Fn::Join": [
                            "",
                            [
                                "arn:",
                                { "Ref": "AWS::Partition" },
                                ":ecr:",
                                { "Ref": "AWS::Region" },
                                ":",
                                { "Ref": "AWS::AccountId" },
                                ":repository/",
                                repo_capture.as_string()
                            ]
                        ]
                    }
                }
            ],
            "Version": "2012-10-17"
        }
    })