def test_template(template: Template):
    # VPC with public subnet
    template.has_resource_properties("AWS::EC2::VPC", {
        "CidrBlock": Match.any_value(),
        "EnableDnsSupport": Match.any_value(),
        "EnableDnsHostnames": Match.any_value()
    })
    template.has_resource_properties("AWS::EC2::Subnet", {
        "VpcId": Match.any_value(),
        "CidrBlock": Match.any_value(),
        "MapPublicIpOnLaunch": Match.any_value()
    })
    template.has_resource_properties("AWS::EC2::InternetGateway", {})
    template.has_resource_properties("AWS::EC2::VPCGatewayAttachment", {
        "InternetGatewayId": Match.any_value(),
        "VpcId": Match.any_value()
    })
    template.has_resource_properties("AWS::EC2::RouteTable", {
        "VpcId": Match.any_value()
    })
    template.has_resource_properties("AWS::EC2::Route", {
        "RouteTableId": Match.any_value(),
        "DestinationCidrBlock": "0.0.0.0/0",
        "GatewayId": Match.any_value()
    })
    template.has_resource_properties("AWS::EC2::SubnetRouteTableAssociation", {
        "RouteTableId": Match.any_value(),
        "SubnetId": Match.any_value()
    })

    # Security Group allowing HTTP
    template.has_resource_properties("AWS::EC2::SecurityGroup", {
        "GroupDescription": Match.any_value(),
        "SecurityGroupIngress": Match.array_with([{
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIp": Match.any_value()
        }])
    })

    # EC2 Instance with IAM role for CloudWatch and SSM
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": Match.object_like({
            "Statement": Match.array_with([{
                "Effect": "Allow",
                "Principal": Match.object_like({
                    "Service": "ec2.amazonaws.com"
                }),
                "Action": "sts:AssumeRole"
            }])
        })
    })
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": Match.object_like({
            "Statement": Match.array_with([{
                "Effect": "Allow",
                "Action": Match.array_with([
                    "cloudwatch:*",
                    "logs:*",
                    "ssm:*"
                ]),
                "Resource": "*"
            }])
        })
    })
    template.has_resource_properties("AWS::EC2::Instance", {
        "ImageId": Match.any_value(),
        "InstanceType": Match.any_value(),
        "IamInstanceProfile": Match.any_value(),
        "SecurityGroupIds": Match.any_value(),
        "SubnetId": Match.any_value(),
        "UserData": Match.any_value()
    })

    # S3 bucket with encryption and restricted public access
    template.has_resource_properties("AWS::S3::Bucket", {
        "BucketEncryption": Match.object_like({
            "ServerSideEncryptionConfiguration": Match.array_with([{
                "ServerSideEncryptionByDefault": Match.object_like({
                    "SSEAlgorithm": "AES256"
                })
            }])
        }),
        "PublicAccessBlockConfiguration": Match.object_like({
            "BlockPublicAcls": True,
            "BlockPublicPolicy": True,
            "IgnorePublicAcls": True,
            "RestrictPublicBuckets": True
        })
    })
    template.has_resource_properties("AWS::S3::BucketPolicy", {
        "Bucket": Match.any_value(),
        "PolicyDocument": Match.object_like({
            "Statement": Match.array_with([{
                "Effect": "Allow",
                "Principal": Match.object_like({
                    "Service": "logs.amazonaws.com"
                }),
                "Action": "s3:PutObject",
                "Resource": Match.string_like_regexp("arn:aws:s3:::%s/.*")
            }])
        })
    })