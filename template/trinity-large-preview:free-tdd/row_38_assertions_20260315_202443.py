def test_template(template: Template):
    # Assert that exactly one Lambda Function is created
    template.resource_count_is("AWS::Lambda::Function", 1)

    # Assert that exactly one S3 Bucket is created
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert that exactly one S3 Bucket Notification exists
    template.resource_count_is("AWS::Lambda::Permission", 1)

    # Assert that the Lambda Permission allows S3 to invoke the Lambda
    template.has_resource_properties("AWS::Lambda::Permission", {
        "Principal": "s3.amazonaws.com",
        "Action": "lambda:InvokeFunction"
    })

    # Capture the Lambda Function ARN for use in the S3 Notification assertion
    lambda_arn = Capture()

    # Assert that the S3 Bucket Notification references the Lambda Function
    template.has_resource_properties("AWS::S3::Bucket", {
        "NotificationConfiguration": {
            "LambdaConfigurations": [{
                "Function": Match.string_like_regexp(lambda_arn),
                "Event": Match.any_value(),
                "Filter": Match.any_value()
            }]
        }
    })