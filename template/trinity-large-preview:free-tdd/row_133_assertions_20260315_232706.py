def test_template(template: Template):
    # VPC
    template.resource_count_is("AWS::EC2::VPC", 1)
    # Subnet
    template.resource_count_is("AWS::EC2::Subnet", 1)
    # Security Group
    template.resource_count_is("AWS::EC2::SecurityGroup", 1)
    # EC2 Instance
    template.resource_count_is("AWS::EC2::Instance", 1)
    # EC2 Instance properties
    template.has_resource_properties("AWS::EC2::Instance", {
        "InstanceType": "t2.micro",
        "ImageId": Match.string_like_regexp("ami-.*"),
        "SecurityGroupIds": Match.array_with(Match.string_like_regexp("sg-.*")),
        "UserData": Match.any_value(),
        "SubnetId": Match.string_like_regexp("subnet-.*")
    })
    # Security Group properties
    template.has_resource_properties("AWS::EC2::SecurityGroup", {
        "SecurityGroupIngress": Match.array_with({
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIp": "0.0.0.0/0"
        })
    })