def test_template(template: Template):
    # VPC with public and private subnets
    template.has_resource_properties("AWS::EC2::VPC", {
        "CidrBlock": Match.any_value(),
        "EnableDnsSupport": True,
        "EnableDnsHostnames": True
    })

    # Two public subnets
    template.resource_count_is("AWS::EC2::Subnet", 4)
    public_subnets = template.find_resources("AWS::EC2::Subnet", {
        "Tags": Match.array_with({
            "Key": "Network",
            "Value": "Public"
        })
    })
    assert len(public_subnets) == 2

    # Two private subnets
    private_subnets = template.find_resources("AWS::EC2::Subnet", {
        "Tags": Match.array_with({
            "Key": "Network",
            "Value": "Private"
        })
    })
    assert len(private_subnets) == 2

    # NAT Gateway
    template.has_resource_properties("AWS::EC2::NatGateway", {
        "AllocationId": Match.any_value(),
        "SubnetId": Match.any_value()
    })

    # Public security group allowing HTTP globally
    template.has_resource_properties("AWS::EC2::SecurityGroup", {
        "GroupDescription": Match.string_like_regexp("Public"),
        "SecurityGroupIngress": Match.array_with({
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIp": "0.0.0.0/0"
        })
    })

    # Private security group allowing HTTPS from public SG
    template.has_resource_properties("AWS::EC2::SecurityGroup", {
        "GroupDescription": Match.string_like_regexp("Private"),
        "SecurityGroupIngress": Match.array_with({
            "IpProtocol": "tcp",
            "FromPort": 443,
            "ToPort": 443,
            "SourceSecurityGroupId": Match.any_value()
        })
    })

    # Public EC2 instance with SSM role
    template.has_resource_properties("AWS::EC2::Instance", {
        "Tags": Match.array_with({
            "Key": "Name",
            "Value": "PublicInstance"
        }),
        "IamInstanceProfile": Match.any_value(),
        "SecurityGroupIds": Match.array_with(Match.any_value())
    })

    # Private EC2 instance with SSM role
    template.has_resource_properties("AWS::EC2::Instance", {
        "Tags": Match.array_with({
            "Key": "Name",
            "Value": "PrivateInstance"
        }),
        "IamInstanceProfile": Match.any_value(),
        "SecurityGroupIds": Match.array_with(Match.any_value())
    })

    # IAM role with SSM policy
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": Match.object_like({
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            })
        }),
        "ManagedPolicyArns": Match.array_with(
            "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        )
    })

    # Route tables for public subnets
    template.resource_count_is("AWS::EC2::RouteTable", 2)
    template.has_resource_properties("AWS::EC2::Route", {
        "DestinationCidrBlock": "0.0.0.0/0",
        "GatewayId": Match.string_like_regexp("igw-")
    })

    # Route tables for private subnets via NAT
    template.has_resource_properties("AWS::EC2::Route", {
        "DestinationCidrBlock": "0.0.0.0/0",
        "NatGatewayId": Match.any_value()
    })