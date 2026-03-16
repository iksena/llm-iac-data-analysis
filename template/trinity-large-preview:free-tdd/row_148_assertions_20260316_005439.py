def test_template(template: Template):
    # Assert VPC exists
    template.resource_count_is("AWS::EC2::VPC", 1)

    # Assert two public subnets
    template.resource_count_is("AWS::EC2::Subnet", 2)

    # Assert Internet Gateway
    template.resource_count_is("AWS::EC2::InternetGateway", 1)

    # Assert VPC Gateway Attachment
    template.resource_count_is("AWS::EC2::VPCGatewayAttachment", 1)

    # Assert Route Table for public subnets
    template.resource_count_is("AWS::EC2::RouteTable", 1)

    # Assert Routes for internet access
    template.resource_count_is("AWS::EC2::Route", 1)

    # Assert Subnet Route Table Association (2 associations)
    template.resource_count_is("AWS::EC2::SubnetRouteTableAssociation", 2)

    # Assert Network ACL for public subnets
    template.resource_count_is("AWS::EC2::NetworkAcl", 1)

    # Assert Network ACL Entry for inbound/outbound traffic
    template.resource_count_is("AWS::EC2::NetworkAclEntry", 2)

    # Assert IAM Role for SSM access
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert Instance Profile
    template.resource_count_is("AWS::IAM::InstanceProfile", 1)

    # Assert Launch Template for Jenkins
    template.resource_count_is("AWS::EC2::LaunchTemplate", 1)

    # Assert Auto Scaling Group
    template.resource_count_is("AWS::AutoScaling::AutoScalingGroup", 1)

    # Assert Security Group for Jenkins instances
    template.resource_count_is("AWS::EC2::SecurityGroup", 1)