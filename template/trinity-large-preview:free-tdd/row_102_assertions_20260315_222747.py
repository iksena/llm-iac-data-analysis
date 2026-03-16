def test_template(template: Template):
    # Assert Lambda functions
    template.resource_count_is("AWS::Lambda::Function", 2)

    # Assert DynamoDB table
    template.resource_count_is("AWS::DynamoDB::Table", 1)

    # Assert IAM role for Lambda functions
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert SNS Topic
    template.resource_count_is("AWS::SNS::Topic", 1)

    # Assert SNS Topic Policy for SSM OpsCenter
    template.has_resource_properties("AWS::SNS::TopicPolicy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Principal": {
                    "Service": "ssm-opscenter.amazonaws.com"
                },
                "Action": "sns:Publish"
            })
        }
    })