def test_template(template: Template):
    # Assert Kinesis Stream exists
    template.resource_count_is("AWS::Kinesis::Stream", 1)

    # Assert REST API Gateway exists
    template.resource_count_is("AWS::ApiGateway::RestApi", 1)

    # Assert IAM Role for API Gateway exists
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert API Gateway Method for PUT record exists
    template.has_resource_properties("AWS::ApiGateway::Method", {
        "HttpMethod": "PUT",
        "AuthorizationType": "NONE"
    })

    # Assert API Gateway Method for GET records exists
    template.has_resource_properties("AWS::ApiGateway::Method", {
        "HttpMethod": "GET",
        "AuthorizationType": "NONE"
    })

    # Assert API Gateway Integration for Kinesis PutRecord exists
    template.has_resource_properties("AWS::ApiGateway::Integration", {
        "IntegrationHttpMethod": "POST",
        "Type": "AWS",
        "Uri": Match.string_like_regexp("arn:aws:apigateway:.*kinesis:.*PutRecord")
    })

    # Assert API Gateway Integration for Kinesis GetRecords exists
    template.has_resource_properties("AWS::ApiGateway::Integration", {
        "IntegrationHttpMethod": "POST",
        "Type": "AWS",
        "Uri": Match.string_like_regexp("arn:aws:apigateway:.*kinesis:.*GetRecords")
    })

    # Assert IAM Role has Kinesis permissions
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": [{
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": {"Service": "apigateway.amazonaws.com"}
            }]
        }
    })

    # Assert IAM Role has Kinesis actions in policy
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Action": Match.array_with(
                    "kinesis:PutRecord",
                    "kinesis:PutRecords",
                    "kinesis:GetRecords",
                    "kinesis:GetShardIterator",
                    "kinesis:DescribeStream",
                    "kinesis:ListStreams"
                ),
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:kinesis:.*")
            })
        }
    })