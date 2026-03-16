def test_template(template: Template):
    # Assert S3 bucket exists
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert SNS topic exists
    template.resource_count_is("AWS::SNS::Topic", 1)

    # Assert bucket notification configuration exists
    template.has_resource_properties("AWS::S3::Bucket", {
        "NotificationConfiguration": {
            "TopicConfigurations": [{
                "Topic": Match.string_like_regexp("arn:aws:sns:.*"),
                "Events": ["s3:ObjectCreated:*"]
            }]
        }
    })

    # Assert SNS topic policy exists
    template.has_resource_properties("AWS::SNS::TopicPolicy", {
        "PolicyDocument": {
            "Statement": [{
                "Effect": "Allow",
                "Principal": {"Service": "s3.amazonaws.com"},
                "Action": "sns:Publish",
                "Resource": Match.string_like_regexp("arn:aws:sns:.*")
            }]
        }
    })