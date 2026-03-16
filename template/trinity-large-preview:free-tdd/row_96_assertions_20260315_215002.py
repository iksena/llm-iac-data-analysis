def test_template(template: Template):
    # VPC with public and private subnets across three AZs
    template.has_resource_properties("AWS::EC2::VPC", {
        "CidrBlock": Match.string_like_regexp(r"\d+\.\d+\.\d+\.\d+/\d+"),
        "EnableDnsSupport": True,
        "EnableDnsHostnames": True
    })
    template.resource_count_is("AWS::EC2::VPC", 1)

    # Public subnets with internet gateway
    template.resource_count_is("AWS::EC2::Subnet", 6)  # 3 public + 3 private
    template.has_resource_properties("AWS::EC2::Subnet", {
        "MapPublicIpOnLaunch": True
    }, count=3)  # public subnets

    # Private subnets
    template.has_resource_properties("AWS::EC2::Subnet", {
        "MapPublicIpOnLaunch": False
    }, count=3)  # private subnets

    # Internet Gateway
    template.resource_count_is("AWS::EC2::InternetGateway", 1)

    # NAT Gateway
    template.resource_count_is("AWS::EC2::NatGateway", 1)

    # Security groups (count may vary based on implementation)
    template.resource_count_is("AWS::EC2::SecurityGroup", Match.any_value)

    # Internal ALB
    template.has_resource_properties("AWS::ElasticLoadBalancingV2::LoadBalancer", {
        "Scheme": "internal"
    })
    template.resource_count_is("AWS::ElasticLoadBalancingV2::LoadBalancer", 1)

    # ALB listener on port 80
    template.has_resource_properties("AWS::ElasticLoadBalancingV2::Listener", {
        "Port": 80
    })

    # ECR repository with image scanning
    template.has_resource_properties("AWS::ECR::Repository", {
        "ImageScanningConfiguration": {
            "ScanOnPush": True
        }
    })
    template.resource_count_is("AWS::ECR::Repository", 1)

    # SSM Parameter Store outputs for critical resource IDs
    template.has_output("VPCId")
    template.has_output("PrivateSubnetIds")
    template.has_output("PublicSubnetIds")
    template.has_output("SecurityGroupIds")
    template.has_output("ALBListenerArn")