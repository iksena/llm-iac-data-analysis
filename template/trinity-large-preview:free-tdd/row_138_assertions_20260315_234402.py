def test_template(template: Template):
    # Assert VPC and EC2 instance in public subnet
    template.has_resource_properties("AWS::EC2::VPC", {})
    template.has_resource_properties("AWS::EC2::Instance", {
        "SubnetId": Match.string_like_regexp(".*Public.*")
    })

    # Assert S3 bucket for static assets
    template.has_resource_properties("AWS::S3::Bucket", {})

    # Assert DynamoDB table with composite keys
    template.has_resource_properties("AWS::DynamoDB::Table", {
        "TableName": "AWS-Services",
        "KeySchema": Match.array_with(
            Match.object_like({"AttributeName": "PartitionKey"}),
            Match.object_like({"AttributeName": "SortKey"})
        )
    })

    # Assert IAM role with S3 and DynamoDB permissions
    template.has_resource_properties("AWS::IAM::Role", {
        "Policies": Match.array_with(
            Match.object_like({
                "PolicyDocument": Match.object_like({
                    "Statement": Match.array_with(
                        Match.object_like({
                            "Effect": "Allow",
                            "Action": Match.array_with("s3:*", "dynamodb:*")
                        })
                    )
                })
            })
        )
    })

    # Assert EC2 instance has IAM role attached
    template.has_resource_properties("AWS::EC2::Instance", {
        "IamInstanceProfile": Match.any_value()
    })

    # Assert UserData scripts for automation (basic structure)
    template.has_resource_properties("AWS::EC2::Instance", {
        "UserData": Match.string_like_regexp(
            ".*yum.*install.*php.*",
            ".*aws.*sdk.*",
            ".*dynamodb.*",
            ".*s3.*"
        )
    })

    # Assert resource counts
    template.resource_count_is("AWS::EC2::VPC", 1)
    template.resource_count_is("AWS::EC2::Instance", 1)
    template.resource_count_is("AWS::S3::Bucket", 1)
    template.resource_count_is("AWS::DynamoDB::Table", 1)
    template.resource_count_is("AWS::IAM::Role", 1)