def test_template(template: Template):
    # Assert Lambda function exists
    template.resource_count_is("AWS::Lambda::Function", 1)

    # Assert IAM Role for Lambda exists
    template.resource_count_is("AWS::IAM::Role", 2)

    # Assert Bedrock Agent exists
    template.resource_count_is("AWS::AmazonBedrock::Agent", 1)

    # Assert Lambda function has logging permissions
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow"
            })
        }
    })

    # Assert Bedrock Agent has bedrock:InvokeModel permission
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Action": "bedrock:InvokeModel",
                "Effect": "Allow"
            })
        }
    })

    # Assert Bedrock Agent is configured with a foundational model
    template.has_resource_properties("AWS::AmazonBedrock::Agent", {
        "AgentName": Match.string_like_regexp(".*"),
        "ModelConfiguration": {
            "ModelId": Match.string_like_regexp(".*")
        }
    })

    # Assert Bedrock Agent has instructions for stock-related queries
    template.has_resource_properties("AWS::AmazonBedrock::Agent", {
        "Instructions": Match.string_like_regexp(".*stock.*")
    })

    # Assert Lambda function is linked to Bedrock Agent via action group
    template.has_resource_properties("AWS::AmazonBedrock::Agent", {
        "ActionGroups": Match.array_with({
            "Name": Match.string_like_regexp(".*"),
            "Type": "Lambda",
            "Parameters": {
                "Name": "symbol",
                "Type": "String"
            }
        })
    })