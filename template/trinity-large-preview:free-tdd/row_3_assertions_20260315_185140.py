def test_template(template: Template):
    # Assert exactly one S3 bucket is created
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert the bucket has website hosting configuration
    template.has_resource_properties("AWS::S3::Bucket", {
        "WebsiteConfiguration": Match.any_value()
    })

    # Assert DeletionPolicy is set to Retain
    template.has_resource_properties("AWS::S3::Bucket", {
        "DeletionPolicy": "Retain"
    })