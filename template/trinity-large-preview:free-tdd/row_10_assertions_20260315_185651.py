def test_template(template: Template):
    # Assert EC2 instance with block device mappings
    template.has_resource_properties(
        "AWS::EC2::Instance",
        {
            "BlockDeviceMappings": Match.any_value(),
            "ImageId": Match.string_like_regexp("/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-2.0-x86_64-gp2"),
            "KeyName": Match.any_value(),
        },
    )

    # Assert exactly one EC2 instance
    template.resource_count_is("AWS::EC2::Instance", 1)

    # Assert SSH key pair is created
    template.has_resource_properties(
        "AWS::EC2::KeyPair",
        {
            "KeyName": Match.any_value(),
        },
    )

    # Assert exactly one key pair
    template.resource_count_is("AWS::EC2::KeyPair", 1)