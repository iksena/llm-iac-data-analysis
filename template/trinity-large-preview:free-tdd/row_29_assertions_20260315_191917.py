def test_template(template: Template):
    # Assert SSM Parameter resource exists
    template.resource_count_is("AWS::SSM::Parameter", 1)

    # Assert SSM Parameter properties (non-sensitive config)
    template.has_resource_properties("AWS::SSM::Parameter", {
        "Name": Match.string_like_regexp("/.*/This is A/B"),
        "Type": "String",
        "Value": "This is A/B"
    })

    # Assert Secrets Manager Secret resource exists
    template.resource_count_is("AWS::SecretsManager::Secret", 1)

    # Assert Secrets Manager Secret properties
    template.has_resource_properties("AWS::SecretsManager::Secret", {
        "Name": Match.string_like_regexp("/.*/"),
        "GenerateSecretString": {
            "ExcludeCharacters": Match.any_value(),
            "GenerateStringKey": "password",
            "PasswordLength": Match.any_value(),
            "SecretStringTemplate": Match.string_like_regexp("\"username\": \"")
        }
    })

    # Assert Lambda Function resource exists
    template.resource_count_is("AWS::Lambda::Function", 1)

    # Assert Lambda IAM Role exists
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert Lambda Execution Policy exists
    template.resource_count_is("AWS::IAM::Policy", 1)

    # Assert Lambda has SSM permissions
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Action": Match.array_with("ssm:GetParameter", "ssm:GetParametersByPath"),
                "Resource": Match.string_like_regexp("arn:aws:ssm:")
            })
        }
    })

    # Assert Lambda has Secrets Manager permissions
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Action": Match.array_with("secretsmanager:GetSecretValue"),
                "Resource": Match.string_like_regexp("arn:aws:secretsmanager:")
            })
        }
    })

    # Assert Lambda has CloudWatch permissions
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Action": Match.array_with("logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"),
                "Resource": Match.string_like_regexp("arn:aws:logs:")
            })
        }
    })