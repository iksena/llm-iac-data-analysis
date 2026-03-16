def test_template(template: Template):
    # Assert RDS instance with correct engine and instance class
    template.has_resource_properties(
        "AWS::RDS::DBInstance",
        {
            "Engine": "mysql",
            "DBInstanceClass": "db.r5.large",
            "StorageType": "io1",
            "DBSubnetGroupName": Match.any_value(),
            "VPCSecurityGroups": Match.any_value(),
            "Port": 3306
        }
    )

    # Assert exactly one RDS instance
    template.resource_count_is("AWS::RDS::DBInstance", 1)

    # Assert VPC exists
    template.has_resource_properties(
        "AWS::EC2::VPC",
        {}
    )

    # Assert DB subnet group exists
    template.has_resource_properties(
        "AWS::RDS::DBSubnetGroup",
        {
            "DBSubnetGroupType": "MultiAZ"
        }
    )

    # Assert security group exists with port 3306
    template.has_resource_properties(
        "AWS::EC2::SecurityGroup",
        {
            "SecurityGroupIngress": Match.array_with(
                {
                    "FromPort": 3306,
                    "ToPort": 3306,
                    "IpProtocol": "tcp"
                }
            )
        }
    )

    # Assert two private subnets in different AZs
    template.resource_count_is("AWS::EC2::Subnet", 2)
    template.has_resource_properties(
        "AWS::EC2::Subnet",
        {
            "MapPublicIpOnLaunch": False
        }
    )