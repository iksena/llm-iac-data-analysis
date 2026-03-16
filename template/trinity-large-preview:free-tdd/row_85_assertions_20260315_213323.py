def test_template(template: Template):
    # Assert exactly one S3 bucket is created
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert the bucket has versioning enabled (as required for secure storage)
    template.has_resource_properties("AWS::S3::Bucket", {
        "VersioningConfiguration": {
            "Status": "Enabled"
        }
    })

    # Assert lifecycle configuration exists for cost optimization
    template.has_resource_properties("AWS::S3::Bucket", {
        "LifecycleConfiguration": Match.any_value()
    })

    # Assert bucket has server-side encryption enabled (secure storage)
    template.has_resource_properties("AWS::S3::Bucket", {
        "BucketEncryption": Match.any_value()
    })

    # Assert bucket has block public access enabled (secure storage)
    template.has_resource_properties("AWS::S3::Bucket", {
        "PublicAccessBlockConfiguration": Match.any_value()
    })