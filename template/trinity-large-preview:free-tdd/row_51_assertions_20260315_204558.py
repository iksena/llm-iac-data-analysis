def test_template(template: Template):
    # Assert Application Load Balancer
    template.has_resource_properties(
        "AWS::ElasticLoadBalancingV2::LoadBalancer",
        {
            "Type": "application",
            "Scheme": "internet-facing",
        }
    )

    # Assert Auto Scaling Group
    template.has_resource_properties(
        "AWS::AutoScaling::AutoScalingGroup",
        {
            "MinSize": 1,
            "MaxSize": 5,
            "DesiredCapacity": 2,
            "VPCZoneIdentifier": Match.array_with(Match.any_value()),
            "TargetGroupARNs": Match.array_with(Match.any_value()),
        }
    )

    # Assert Launch Template with UserData
    template.has_resource_properties(
        "AWS::EC2::LaunchTemplate",
        {
            "LaunchTemplateName": Match.string_like_regexp(".*"),
            "UserData": Match.string_like_regexp(
                ".*yum.*install.*httpd.*-y.*"
                ".*echo.*<html>.*</html>.*"
                ".*systemctl.*start.*httpd.*"
            ),
        }
    )

    # Assert IAM Role for SSM access
    template.has_resource_properties(
        "AWS::IAM::Role",
        {
            "AssumeRolePolicyDocument": {
                "Statement": Match.array_with(
                    {
                        "Effect": "Allow",
                        "Principal": {"Service": "ec2.amazonaws.com"},
                        "Action": "sts:AssumeRole",
                    }
                )
            },
            "ManagedPolicyArns": Match.array_with(
                Match.string_like_regexp(".*AmazonSSMManagedInstanceCore.*")
            ),
        }
    )

    # Assert Security Group for ALB
    template.has_resource_properties(
        "AWS::EC2::SecurityGroup",
        {
            "GroupDescription": "ALB Security Group",
            "SecurityGroupIngress": Match.array_with(
                {
                    "IpProtocol": "tcp",
                    "FromPort": 80,
                    "ToPort": 80,
                    "CidrIp": "0.0.0.0/0",
                }
            ),
        }
    )

    # Assert Security Group for EC2 instances
    template.has_resource_properties(
        "AWS::EC2::SecurityGroup",
        {
            "GroupDescription": "EC2 Security Group",
            "SecurityGroupIngress": Match.array_with(
                {
                    "IpProtocol": "tcp",
                    "FromPort": 80,
                    "ToPort": 80,
                    "SourceSecurityGroupId": Match.string_like_regexp(".*"),
                }
            ),
        }
    )

    # Assert Listener on ALB
    template.has_resource_properties(
        "AWS::ElasticLoadBalancingV2::Listener",
        {
            "Protocol": "HTTP",
            "Port": 80,
            "DefaultActions": Match.array_with(
                {
                    "Type": "forward",
                    "TargetGroupArn": Match.string_like_regexp(".*"),
                }
            ),
        }
    )

    # Assert Target Group
    template.has_resource_properties(
        "AWS::ElasticLoadBalancingV2::TargetGroup",
        {
            "Protocol": "HTTP",
            "Port": 80,
            "HealthCheckPath": "/",
            "HealthCheckProtocol": "HTTP",
        }
    )

    # Assert resource counts
    template.resource_count_is("AWS::ElasticLoadBalancingV2::LoadBalancer", 1)
    template.resource_count_is("AWS::AutoScaling::AutoScalingGroup", 1)
    template.resource_count_is("AWS::EC2::LaunchTemplate", 1)
    template.resource_count_is("AWS::IAM::Role", 1)
    template.resource_count_is("AWS::EC2::SecurityGroup", 2)
    template.resource_count_is("AWS::ElasticLoadBalancingV2::Listener", 1)
    template.resource_count_is("AWS::ElasticLoadBalancingV2::TargetGroup", 1)