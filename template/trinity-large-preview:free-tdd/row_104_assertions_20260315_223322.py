def test_template(template: Template):
    # VPC with public subnet, internet gateway, and route tables
    template.has_resource_properties("AWS::EC2::VPC", {
        "CidrBlock": Match.string_like_regexp(r"\d+\.\d+\.\d+\.\d+/\d+")
    })
    template.has_resource_properties("AWS::EC2::Subnet", {
        "MapPublicIpOnLaunch": True
    })
    template.has_resource_properties("AWS::EC2::InternetGateway", {})
    template.has_resource_properties("AWS::EC2::RouteTable", {})
    template.has_resource_properties("AWS::EC2::Route", {
        "DestinationCidrBlock": "0.0.0.0/0"
    })

    # Five t3.nano EC2 instances tagged with environment: dev
    template.resource_count_is("AWS::EC2::Instance", 6)
    template.has_resource_properties("AWS::EC2::Instance", {
        "InstanceType": "t3.nano",
        "Tags": Match.array_with({
            "Key": "environment",
            "Value": "dev"
        })
    })

    # Admin instance with Instance Scheduler CLI installation
    template.has_resource_properties("AWS::EC2::Instance", {
        "UserData": Match.string_like_regexp(r"aws-instance-scheduler")
    })

    # IAM role for admin instance with Lambda and CloudFormation permissions
    template.has_resource_properties("AWS::IAM::Role", {
        "Policies": Match.array_with({
            "PolicyDocument": Match.object_like({
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Action": Match.array_with(
                        Match.string_like_regexp("lambda:*"),
                        Match.string_like_regexp("cloudformation:*")
                    )
                })
            })
        })
    })

    # Security group with unrestricted outbound traffic
    template.has_resource_properties("AWS::EC2::SecurityGroup", {
        "SecurityGroupEgress": Match.array_with({
            "CidrIp": "0.0.0.0/0",
            "IpProtocol": "-1"
        })
    })

    # SSM management for all instances
    template.has_resource_properties("AWS::EC2::Instance", {
        "IamInstanceProfile": Match.string_like_regexp(".*SSM.*")
    })