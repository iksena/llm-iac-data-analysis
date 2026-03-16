def test_template(template: Template):
    # EC2 Instance
    template.resource_count_is("AWS::EC2::Instance", 1)
    template.has_resource_properties("AWS::EC2::Instance", {
        "ImageId": Match.any_value(),
        "InstanceType": Match.any_value()
    })

    # Security Group allowing HTTP access
    template.resource_count_is("AWS::EC2::SecurityGroup", 1)
    template.has_resource_properties("AWS::EC2::SecurityGroup", {
        "SecurityGroupIngress": Match.array_with({
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIp": Match.string_like_regexp(r"\d+\.\d+\.\d+\.\d+/0")
        })
    })

    # S3 Bucket
    template.resource_count_is("AWS::S3::Bucket", 1)
    template.has_resource_properties("AWS::S3::Bucket", {})