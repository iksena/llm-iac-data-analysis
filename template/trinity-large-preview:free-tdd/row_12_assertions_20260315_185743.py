def test_template(template: Template):
    # EC2 instance
    template.resource_count_is("AWS::EC2::Instance", 1)
    template.has_resource_properties("AWS::EC2::Instance", {
        "ImageId": Match.any_value(),
        "InstanceType": Match.any_value(),
        "KeyName": Match.any_value(),
        "SecurityGroupIds": Match.any_value()
    })

    # Elastic IP
    template.resource_count_is("AWS::EC2::EIP", 1)
    template.has_resource_properties("AWS::EC2::EIP", {
        "Domain": "vpc"
    })

    # Associate EIP with EC2 instance
    template.resource_count_is("AWS::EC2::EIPAssociation", 1)
    template.has_resource_properties("AWS::EC2::EIPAssociation", {
        "InstanceId": Match.any_value(),
        "EIP": Match.any_value()
    })

    # Security Group for SSH access
    template.resource_count_is("AWS::EC2::SecurityGroup", 1)
    template.has_resource_properties("AWS::EC2::SecurityGroup", {
        "GroupDescription": Match.any_value(),
        "SecurityGroupIngress": Match.array_with([
            Match.object_like({
                "IpProtocol": "tcp",
                "FromPort": 22,
                "ToPort": 22,
                "CidrIp": Match.any_value()
            })
        ])
    })