def test_template(template: Template):
    # Assert IAM Role exists
    template.resource_count_is("AWS::IAM::Role", 1)

    # Capture the Role ARN for later use
    role_arn = Capture()

    # Assert Role properties
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": [{
                "Effect": "Allow",
                "Principal": {
                    "Service": "bedrock.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }]
        },
        "Path": "/",
        "Policies": Match.array_with({
            "PolicyDocument": {
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Action": "lambda:InvokeFunction",
                    "Resource": "*"
                }),
                "Version": "2012-10-17"
            },
            "PolicyName": Match.string_like_regexp(".*")
        })
    })

    # Assert specific permissions for Bedrock agent resources
    template.has_resource_properties("AWS::IAM::Role", {
        "Policies": Match.array_with({
            "PolicyDocument": {
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Action": "bedrock:*",
                    "Resource": "agent/*"
                })
            }
        })
    })

    # Assert permissions for invoking any Bedrock foundation model
    template.has_resource_properties("AWS::IAM::Role", {
        "Policies": Match.array_with({
            "PolicyDocument": {
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Action": "bedrock:InvokeModel",
                    "Resource": "*"
                })
            }
        })
    })