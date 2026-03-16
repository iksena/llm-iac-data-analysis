def test_template(template: Template):
    # Assert EC2 Auto Scaling Groups
    template.resource_count_is("AWS::AutoScaling::AutoScalingGroup", 2)

    # Assert Launch Templates
    template.resource_count_is("AWS::EC2::LaunchTemplate", 2)

    # Assert SSM Role
    template.resource_count_is("AWS::IAM::Role", 1)
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": [{
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": {"Service": "ec2.amazonaws.com"}
            }]
        },
        "ManagedPolicyArns": [{
            "Fn::Join": ["", [
                "arn:", Match.any_value(), ":iam::aws:policy/service-role/AmazonEC2RoleforSSM"
            ]]
        }]
    })

    # Assert VPC
    template.resource_count_is("AWS::EC2::VPC", 1)
    template.resource_count_is("AWS::EC2::InternetGateway", 1)
    template.resource_count_is("AWS::EC2::VPCGatewayAttachment", 1)

    # Assert Subnets
    template.resource_count_is("AWS::EC2::Subnet", 2)

    # Assert Security Group
    template.resource_count_is("AWS::EC2::SecurityGroup", 1)
    template.has_resource_properties("AWS::EC2::SecurityGroup", {
        "SecurityGroupIngress": [{
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIp": "0.0.0.0/0"
        }]
    })

    # Assert SSM Parameter Store usage for AMIs (Linux)
    template.has_resource_properties("AWS::EC2::LaunchTemplate", {
        "LaunchTemplateName": Match.string_like_regexp(".*Linux.*"),
        "LaunchTemplateData": {
            "ImageId": {
                "Fn::Join": ["", [
                    "arn:", Match.any_value(), ":ssm:", Match.any_value(), ":parameter/amzn2-ami-kernel-5.10-hvm-2.0.*"
                ]]
            }
        }
    })

    # Assert SSM Parameter Store usage for AMIs (Windows)
    template.has_resource_properties("AWS::EC2::LaunchTemplate", {
        "LaunchTemplateName": Match.string_like_regexp(".*Windows.*"),
        "LaunchTemplateData": {
            "ImageId": {
                "Fn::Join": ["", [
                    "arn:", Match.any_value(), ":ssm:", Match.any_value(), ":parameter/windows-ami-2.*"
                ]]
            }
        }
    })

    # Assert User Data for Linux instances (SSM agent installation)
    template.has_resource_properties("AWS::EC2::LaunchTemplate", {
        "LaunchTemplateName": Match.string_like_regexp(".*Linux.*"),
        "LaunchTemplateData": {
            "UserData": Match.string_like_regexp(".*amazon-ssm-agent.*")
        }
    })