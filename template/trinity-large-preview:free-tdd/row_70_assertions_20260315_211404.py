def test_template(template: Template):
    # VPC
    template.resource_count_is("AWS::EC2::VPC", 1)

    # Public subnets
    template.resource_count_is("AWS::EC2::Subnet", 2)
    template.has_resource_properties("AWS::EC2::Subnet", {
        "MapPublicIpOnLaunch": True
    })

    # Private subnets
    template.resource_count_is("AWS::EC2::Subnet", 2)
    template.has_resource_properties("AWS::EC2::Subnet", {
        "MapPublicIpOnLaunch": False
    })

    # Route tables
    template.resource_count_is("AWS::EC2::RouteTable", 2)

    # Routes to the Internet
    template.has_resource_properties("AWS::EC2::Route", {
        "DestinationCidrBlock": "0.0.0.0/0",
        "GatewayId": Match.string_like_regexp("igw-")
    })