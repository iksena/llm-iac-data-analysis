def test_template(template: Template):
    # Assert Lambda function exists
    template.has_resource_properties("AWS::Lambda::Function", {
        "Runtime": Match.any_value(),
        "Handler": Match.any_value(),
        "Code": Match.any_value()
    })

    # Assert IAM Role for Lambda exists
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Principal": {"Service": "lambda.amazonaws.com"},
                "Action": "sts:AssumeRole"
            })
        }
    })

    # Assert Lambda function has the IAM role attached
    template.has_resource_properties("AWS::Lambda::Function", {
        "Role": Match.string_like_regexp("arn:aws:iam::.*:role/.*")
    })

    # Assert CloudWatch Log Group exists
    template.has_resource_properties("AWS::Logs::LogGroup", {
        "RetentionInDays": Match.any_value()
    })

    # Assert Security Hub controls are being managed (Lambda calls Security Hub API)
    # We can't assert specific API calls, but we can assert the Lambda has permissions
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Action": "securityhub:*",
                "Resource": "*"
            })
        }
    })

    # Assert optional permissions boundary is handled
    template.has_resource_properties("AWS::IAM::Role", {
        "PermissionsBoundary": Match.any_value()
    })

    # Assert user-provided parameter for disabling CIS controls exists
    template.has_parameter("DisableCIS140Controls", {
        "Type": "String"
    })