def test_template(template: Template):
    # Assert DynamoDB table with Music name and Artist-Index GSI
    template.has_resource_properties("AWS::DynamoDB::Table", {
        "TableName": "Music",
        "GlobalSecondaryIndexes": Match.array_with({
            "IndexName": "Artist-Index"
        })
    })

    # Assert API Gateway REST API exists
    template.has_resource_properties("AWS::ApiGateway::RestApi", {
        "Name": Match.string_like_regexp(".*")
    })

    # Assert POST method for adding music entries
    template.has_resource_properties("AWS::ApiGateway::Method", {
        "HttpMethod": "POST",
        "AuthorizationType": "AWS_IAM"
    })

    # Assert GET method for retrieving by artist
    template.has_resource_properties("AWS::ApiGateway::Method", {
        "HttpMethod": "GET",
        "AuthorizationType": "AWS_IAM"
    })

    # Assert API Gateway IAM role for DynamoDB access
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": Match.array_with({
                "Principal": {
                    "Service": "apigateway.amazonaws.com"
                }
            })
        }
    })

    # Assert API key resource exists
    template.has_resource_properties("AWS::ApiGateway::ApiKey", {
        "Name": Match.string_like_regexp(".*")
    })

    # Assert usage plan with throttling exists
    template.has_resource_properties("AWS::ApiGateway::UsagePlan", {
        "ApiStages": Match.array_with({
            "Stage": Match.string_like_regexp(".*")
        }),
        "Throttle": Match.object_like({
            "BurstLimit": Match.any_value(),
            "RateLimit": Match.any_value()
        })
    })

    # Assert API Gateway deployment exists
    template.has_resource_properties("AWS::ApiGateway::Deployment", {
        "StageName": Match.string_like_regexp(".*")
    })

    # Assert API Gateway stage exists
    template.has_resource_properties("AWS::ApiGateway::Stage", {
        "DeploymentId": Capture(),
        "StageName": Match.string_like_regexp(".*")
    })