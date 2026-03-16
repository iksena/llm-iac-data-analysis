def test_template(template: Template):
    # Assert VPC resource exists
    template.has_resource_properties("AWS::EC2::VPC", {
        "CidrBlock": Match.any_value(),
        "EnableDnsSupport": Match.any_value(),
        "EnableDnsHostnames": Match.any_value()
    })

    # Assert exactly 3 subnets (2 public, 1 private) across 2 AZs
    template.resource_count_is("AWS::EC2::Subnet", 3)

    # Assert public subnets exist
    public_subnets = template.find_resources("AWS::EC2::Subnet", {
        "Properties": {
            "MapPublicIpOnLaunch": True
        }
    })
    assert len(public_subnets) == 2

    # Assert private subnet exists
    private_subnets = template.find_resources("AWS::EC2::Subnet", {
        "Properties": {
            "MapPublicIpOnLaunch": Match.not_(True)
        }
    })
    assert len(private_subnets) == 1

    # Assert Route Tables for public and private subnets
    template.resource_count_is("AWS::EC2::RouteTable", 2)

    # Assert Internet Gateway exists
    template.has_resource_properties("AWS::EC2::InternetGateway", {})

    # Assert VPC Gateway Attachment exists
    template.has_resource_properties("AWS::EC2::VPCGatewayAttachment", {
        "VpcId": Match.any_value(),
        "InternetGatewayId": Match.any_value()
    })

    # Assert NAT Gateway exists (for private subnet)
    template.has_resource_properties("AWS::EC2::NatGateway", {
        "AllocationId": Match.any_value(),
        "SubnetId": Match.any_value()
    })

    # Assert EIP for NAT Gateway
    template.has_resource_properties("AWS::EC2::EIP", {
        "Domain": "vpc"
    })

    # Assert RegionMap exists
    template.has_resource_properties("AWS::EC2::VPCEndpoint", {
        "VpcEndpointType": "Interface",
        "ServiceName": Match.string_like_regexp(".*com.amazonaws.*"),
        "VpcId": Match.any_value()
    })