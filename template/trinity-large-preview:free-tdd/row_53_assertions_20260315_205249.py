def test_template(template: Template):
    # Assert IAM Role exists with EMR Serverless permissions
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": [{
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": {"Service": "emr-serverless.amazonaws.com"}
            }]
        },
        "Policies": [{
            "PolicyDocument": {
                "Statement": Match.any_value()
            }
        }]
    })

    # Assert S3 Bucket exists
    template.has_resource_properties("AWS::S3::Bucket", {
        "AccessControl": "Private"
    })

    # Assert EMR Serverless Application exists
    template.has_resource_properties("AWS::EMRServerless::Application", {
        "Type": "spark",
        "ReleaseLabel": "emr-6.15.0",
        "AutoStartConfig": Match.any_value(),
        "AutoStopConfig": Match.any_value()
    })

    # Assert EMR Serverless Application resource count is exactly 1
    template.resource_count_is("AWS::EMRServerless::Application", 1)

    # Assert S3 Bucket resource count is exactly 1
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert IAM Role resource count is exactly 1
    template.resource_count_is("AWS::IAM::Role", 1)