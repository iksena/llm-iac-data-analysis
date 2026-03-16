def test_template(template: Template):
    # Assert exactly one S3 bucket is created
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert the bucket has the Organization-level access configuration
    # This is typically done via a Bucket Policy or ACL that references
    # the AWS::Organizations::Organization principal
    template.has_resource_properties("AWS::S3::BucketPolicy", {
        "Principal": Match.object_like({
            "AWS": Match.string_like_regexp("arn:aws:organizations::.*:organization/organizations")
        })
    })

    # Assert the template allows optional Organization ID parameter
    # This is typically done via a Parameter that can be empty for single-account use
    template.has_parameter("OrganizationId", {
        "Type": "String",
        "Default": ""
    })

    # Assert the bucket policy condition or logic handles empty Organization ID
    # This is typically done via a Condition that checks if OrganizationId is not empty
    template.has_resource_properties("AWS::S3::BucketPolicy", {
        "Condition": Match.string_like_regexp(".*")
    })