def test_template(template: Template):
    # VPC
    template.resource_count_is("AWS::EC2::VPC", 1)

    # Security Group
    template.resource_count_is("AWS::EC2::SecurityGroup", 1)

    # S3 Bucket
    template.resource_count_is("AWS::S3::Bucket", 1)

    # DynamoDB Table with deletion protection enabled
    template.has_resource_properties("AWS::DynamoDB::Table", {
        "DeletionProtection": True
    })