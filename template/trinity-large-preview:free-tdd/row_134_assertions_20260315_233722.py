def test_template(template: Template):
    # Assert Lambda function exists
    template.resource_count_is("AWS::Lambda::Function", 1)

    # Assert Lambda function has inline Node.js code
    template.has_resource_properties("AWS::Lambda::Function", {
        "Code": Match.object_like({
            "ZipFile": Match.string_like_regexp("exports.handler")
        })
    })

    # Assert Lambda function has IAM role
    template.has_resource_properties("AWS::Lambda::Function", {
        "Role": Match.string_like_regexp("arn:aws:iam::")
    })

    # Assert IAM role exists
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert IAM role allows CloudWatch Logs
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": Match.object_like({
            "Statement": Match.array_with({
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": Match.object_like({
                    "Service": "lambda.amazonaws.com"
                })
            })
        }),
        "Policies": Match.array_with({
            "PolicyDocument": Match.object_like({
                "Statement": Match.array_with({
                    "Action": Match.array_with("logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"),
                    "Effect": "Allow",
                    "Resource": "*"
                })
            })
        })
    })