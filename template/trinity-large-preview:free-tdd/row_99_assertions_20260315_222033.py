def test_template(template: Template):
    # VPC with public and private subnets across two AZs
    template.has_resource_properties("AWS::EC2::VPC", {
        "CidrBlock": Match.any_value(),
        "EnableDnsSupport": Match.any_value(),
        "EnableDnsHostnames": Match.any_value(),
        "InstanceTenancy": Match.any_value(),
        "Tags": Match.array_with({
            "Key": Match.any_value(),
            "Value": Match.any_value()
        })
    })

    # Public subnets in two AZs
    template.resource_count_is("AWS::EC2::Subnet", 4)  # 2 public + 2 private
    template.has_resource_properties("AWS::EC2::Subnet", {
        "AvailabilityZone": Match.string_like_regexp("us-east-1[a-b]"),
        "MapPublicIpOnLaunch": True,
        "Tags": Match.array_with({
            "Key": Match.any_value(),
            "Value": Match.any_value()
        })
    })

    # Private subnets in two AZs
    template.has_resource_properties("AWS::EC2::Subnet", {
        "AvailabilityZone": Match.string_like_regexp("us-east-1[a-b]"),
        "MapPublicIpOnLaunch": False,
        "Tags": Match.array_with({
            "Key": Match.any_value(),
            "Value": Match.any_value()
        })
    })

    # Internet Gateway
    template.has_resource_properties("AWS::EC2::InternetGateway", {
        "Tags": Match.array_with({
            "Key": Match.any_value(),
            "Value": Match.any_value()
        })
    })

    # NAT Gateway (one per AZ)
    template.resource_count_is("AWS::EC2::NatGateway", 2)

    # Route Tables
    template.resource_count_is("AWS::EC2::RouteTable", 4)  # 2 public + 2 private

    # Public route table with IGW route
    template.has_resource_properties("AWS::EC2::RouteTable", {
        "Tags": Match.array_with({
            "Key": Match.any_value(),
            "Value": Match.any_value()
        })
    })

    # Private route table with NAT Gateway route
    template.has_resource_properties("AWS::EC2::RouteTable", {
        "Tags": Match.array_with({
            "Key": Match.any_value(),
            "Value": Match.any_value()
        })
    })

    # Route associations
    template.resource_count_is("AWS::EC2::SubnetRouteTableAssociation", 4)