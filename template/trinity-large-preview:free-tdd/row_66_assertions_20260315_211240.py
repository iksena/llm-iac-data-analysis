def test_template(template: Template):
    # VPC with a single public subnet
    template.resource_count_is("AWS::EC2::VPC", 1)
    template.resource_count_is("AWS::EC2::Subnet", 1)
    template.resource_count_is("AWS::EC2::InternetGateway", 1)
    template.resource_count_is("AWS::EC2::VPCGatewayAttachment", 1)
    template.resource_count_is("AWS::EC2::RouteTable", 1)
    template.resource_count_is("AWS::EC2::Route", 1)
    template.resource_count_is("AWS::EC2::SubnetRouteTableAssociation", 1)

    # VPC properties
    template.has_resource_properties("AWS::EC2::VPC", {
        "CidrBlock": Match.string_like_regexp(r"\d+\.\d+\.\d+\.\d+/\d+"),
        "EnableDnsSupport": True,
        "EnableDnsHostnames": True
    })

    # Subnet properties (public)
    template.has_resource_properties("AWS::EC2::Subnet", {
        "MapPublicIpOnLaunch": True,
        "AvailabilityZone": Match.any_value()
    })

    # Internet Gateway attachment
    template.has_resource_properties("AWS::EC2::VPCGatewayAttachment", {
        "InternetGatewayId": Match.any_value(),
        "VpcId": Match.any_value()
    })

    # Route table and route
    template.has_resource_properties("AWS::EC2::RouteTable", {
        "VpcId": Match.any_value()
    })

    template.has_resource_properties("AWS::EC2::Route", {
        "DestinationCidrBlock": "0.0.0.0/0",
        "GatewayId": Match.any_value()
    })

    # Subnet route table association
    template.has_resource_properties("AWS::EC2::SubnetRouteTableAssociation", {
        "SubnetId": Match.any_value(),
        "RouteTableId": Match.any_value()
    })