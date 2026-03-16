def test_template(template: Template):
    # Assert B2BI Profile resource exists
    template.has_resource_properties(
        "AWS::B2B::Profile",
        {
            "BusinessContact": {
                "Name": Match.any_value(),
                "Email": Match.any_value(),
                "Phone": Match.any_value()
            }
        }
    )

    # Assert Transformer resource exists
    template.has_resource_properties(
        "AWS::B2B::Transformer",
        {
            "MappingLogic": Match.any_value(),
            "InputFormat": "EDI",
            "OutputFormat": "JSON"
        }
    )

    # Assert Input S3 bucket exists
    template.has_resource_properties(
        "AWS::S3::Bucket",
        {
            "BucketName": Match.string_like_regexp(".*-input")
        }
    )

    # Assert Output S3 bucket exists
    template.has_resource_properties(
        "AWS::S3::Bucket",
        {
            "BucketName": Match.string_like_regexp(".*-output")
        }
    )

    # Assert exactly one of each resource type
    template.resource_count_is("AWS::B2B::Profile", 1)
    template.resource_count_is("AWS::B2B::Transformer", 1)
    template.resource_count_is("AWS::S3::Bucket", 2)