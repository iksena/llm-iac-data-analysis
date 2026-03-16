def test_template(template: Template):
    # EC2 Instance for Jenkins
    template.resource_count_is("AWS::EC2::Instance", 1)

    # VPC
    template.resource_count_is("AWS::EC2::VPC", 1)

    # Security Group allowing HTTP and ICMP
    template.has_resource_properties("AWS::EC2::SecurityGroup", {
        "SecurityGroupIngress": Match.array_with(
            Match.object_like({
                "IpProtocol": "tcp",
                "FromPort": 80,
                "ToPort": 80,
                "CidrIp": "0.0.0.0/0"
            }),
            Match.object_like({
                "IpProtocol": "icmp",
                "FromPort": -1,
                "ToPort": -1,
                "CidrIp": "0.0.0.0/0"
            })
        )
    })

    # Elastic IP
    template.resource_count_is("AWS::EC2::EIP", 1)

    # IAM Role for SSM
    template.has_resource_properties("AWS::IAM::Role", {
        "ManagedPolicyArns": Match.array_with(
            Match.string_like_regexp("arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore")
        )
    })

    # CloudWatch Alarm for automated recovery
    template.has_resource_properties("AWS::CloudWatch::Alarm", {
        "AlarmActions": Match.array_with(
            Match.string_like_regexp("arn:aws:automate:.*:ec2:recover")
        )
    })