def test_template(template: Template):
    # EC2 Instance
    template.has_resource_properties("AWS::EC2::Instance", {
        "ImageId": Match.any_value(),
        "InstanceType": Match.any_value(),
        "IamInstanceProfile": Match.any_value(),
        "UserData": Match.any_value(),
        "NetworkInterfaces": Match.any_value()
    })

    # Security Group
    template.has_resource_properties("AWS::EC2::SecurityGroup", {
        "SecurityGroupIngress": Match.array_with({
            "FromPort": 8080,
            "ToPort": 8080,
            "IpProtocol": "tcp",
            "CidrIp": Match.string_like_regexp(r"^(?:\d{1,3}\.){3}\d{1,3}/\d{1,2}$")
        })
    })

    # VPC
    template.has_resource_properties("AWS::EC2::VPC", {
        "CidrBlock": Match.any_value()
    })

    # Public Subnet
    template.has_resource_properties("AWS::EC2::Subnet", {
        "VpcId": Match.any_value(),
        "CidrBlock": Match.any_value(),
        "MapPublicIpOnLaunch": True
    })

    # CloudFront Distribution
    template.has_resource_properties("AWS::CloudFront::Distribution", {
        "DistributionConfig": {
            "DefaultCacheBehavior": {
                "ViewerProtocolPolicy": "allow-all",
                "MinTTL": 31536000,
                "MaxTTL": 31536000,
                "DefaultTTL": 31536000
            },
            "Origins": Match.array_with({
                "DomainName": Match.any_value(),
                "OriginPath": Match.any_value()
            })
        }
    })

    # SSM Agent
    template.has_resource_properties("AWS::SSM::Association", {
        "Name": "AWS-UpdateSSMAgent",
        "Targets": Match.array_with({
            "Key": "InstanceIds",
            "Values": Match.array_with(Match.any_value())
        })
    })

    # Outputs
    template.has_output("CloudFrontURL", {
        "Value": Match.string_like_regexp(r"^https://.*\.cloudfront\.net$")
    })
    template.has_output("InstanceId", {
        "Value": Match.any_value()
    })
    template.has_output("PublicIP", {
        "Value": Match.string_like_regexp(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$")
    })