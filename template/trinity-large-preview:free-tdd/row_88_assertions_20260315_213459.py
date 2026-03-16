def test_template(template: Template):
    # Assert IAM Role exists
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert the role is assumable by Service Catalog
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": [{
                "Principal": {"Service": "servicecatalog.amazonaws.com"},
                "Effect": "Allow",
                "Action": "sts:AssumeRole"
            }]
        }
    })

    # Assert pre-attached managed policies for S3 and Lambda
    template.has_resource_properties("AWS::IAM::Role", {
        "ManagedPolicyArns": Match.array_with([
            Match.string_like_regexp("arn:aws:iam::aws:policy/AmazonS3FullAccess"),
            Match.string_like_regexp("arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole")
        ])
    })

    # Assert inline policy for granular permissions
    template.has_resource_properties("AWS::IAM::Role", {
        "Policies": Match.array_with([{
            "PolicyDocument": {
                "Statement": Match.array_with([
                    # Service Catalog provisioning
                    Match.object_like({
                        "Effect": "Allow",
                        "Action": "servicecatalog:*",
                        "Resource": "*"
                    }),
                    # IAM role/policy management
                    Match.object_like({
                        "Effect": "Allow",
                        "Action": [
                            "iam:CreateRole",
                            "iam:DeleteRole",
                            "iam:AttachRolePolicy",
                            "iam:DetachRolePolicy",
                            "iam:PutRolePolicy",
                            "iam:DeleteRolePolicy"
                        ],
                        "Resource": "*"
                    }),
                    # Lambda lifecycle
                    Match.object_like({
                        "Effect": "Allow",
                        "Action": [
                            "lambda:CreateFunction",
                            "lambda:DeleteFunction",
                            "lambda:UpdateFunctionCode",
                            "lambda:UpdateFunctionConfiguration",
                            "lambda:GetFunction",
                            "lambda:ListFunctions"
                        ],
                        "Resource": "*"
                    }),
                    # CloudFormation stack operations
                    Match.object_like({
                        "Effect": "Allow",
                        "Action": [
                            "cloudformation:CreateStack",
                            "cloudformation:DeleteStack",
                            "cloudformation:UpdateStack",
                            "cloudformation:DescribeStacks",
                            "cloudformation:DescribeStackEvents",
                            "cloudformation:DescribeStackResource",
                            "cloudformation:DescribeStackResources",
                            "cloudformation:GetTemplate",
                            "cloudformation:ListStacks"
                        ],
                        "Resource": "*"
                    }),
                    # SNS integration
                    Match.object_like({
                        "Effect": "Allow",
                        "Action": [
                            "sns:CreateTopic",
                            "sns:DeleteTopic",
                            "sns:Publish",
                            "sns:Subscribe",
                            "sns:ListSubscriptionsByTopic",
                            "sns:GetTopicAttributes",
                            "sns:SetTopicAttributes"
                        ],
                        "Resource": "*"
                    })
                ])
            }
        }])
    })