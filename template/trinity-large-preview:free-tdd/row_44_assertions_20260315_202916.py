def test_template(template: Template):
    # Assert VPC with Managed NAT Gateway
    template.has_resource_properties(
        "AWS::EC2::VPC",
        {
            "CidrBlock": Match.any_value(),
            "EnableDnsSupport": Match.any_value(),
            "EnableDnsHostnames": Match.any_value()
        }
    )

    # Assert NAT Gateway exists
    template.has_resource_properties(
        "AWS::EC2::NatGateway",
        {
            "ConnectivityType": Match.any_value(),
            "SubnetId": Match.any_value()
        }
    )

    # Assert exactly 4 subnets exist
    template.resource_count_is("AWS::EC2::Subnet", 4)