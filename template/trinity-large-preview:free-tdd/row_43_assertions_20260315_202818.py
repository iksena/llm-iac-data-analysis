def test_template(template: Template):
    # Assert S3 bucket exists
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert KMS Key exists
    template.resource_count_is("AWS::KMS::Key", 1)

    # Assert KMS Key Alias exists
    template.resource_count_is("AWS::KMS::Alias", 1)

    # Assert bucket has server-side encryption with KMS
    template.has_resource_properties("AWS::S3::Bucket", {
        "BucketEncryption": {
            "ServerSideEncryptionConfiguration": Match.array_with({
                "ServerSideEncryptionByDefault": {
                    "KMSMasterKeyID": Capture()
                }
            })
        }
    })

    # Assert bucket has lifecycle configuration
    template.has_resource_properties("AWS::S3::Bucket", {
        "LifecycleConfiguration": Match.any_value()
    })

    # Assert bucket has tags
    template.has_resource_properties("AWS::S3::Bucket", {
        "Tags": Match.any_value()
    })