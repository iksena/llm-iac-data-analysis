def test_template(template: Template):
    # Assert RDS MySQL instance with db.t3.micro class
    template.has_resource_properties(
        "AWS::RDS::DBInstance",
        {
            "DBInstanceClass": "db.t3.micro",
            "Engine": "mysql",
            "DBSubnetGroupName": Match.any_value(),
            "VPCSecurityGroups": Match.any_value(),
            "DBParameterGroupName": Match.any_value(),
        }
    )

    # Assert exactly one RDS instance
    template.resource_count_is("AWS::RDS::DBInstance", 1)

    # Assert VPC with two subnets across AZs
    template.has_resource_properties(
        "AWS::EC2::VPC",
        {
            "CidrBlock": Match.any_value(),
            "EnableDnsSupport": True,
            "EnableDnsHostnames": True,
        }
    )

    # Assert DB subnet group with two subnets
    template.has_resource_properties(
        "AWS::RDS::DBSubnetGroup",
        {
            "DBSubnetGroupDescription": Match.any_value(),
            "SubnetIds": Match.array_with(Match.any_value(), Match.any_value()),
        }
    )

    # Assert Secrets Manager secret for admin credentials
    template.has_resource_properties(
        "AWS::SecretsManager::Secret",
        {
            "GenerateSecretString": Match.object_like({
                "SecretStringTemplate": Match.any_value(),
                "GenerateStringKey": "password",
                "PasswordLength": 16,
                "ExcludeCharacters": Match.any_value(),
            })
        }
    )

    # Assert exactly one Secrets Manager secret
    template.resource_count_is("AWS::SecretsManager::Secret", 1)

    # Assert security group for RDS
    template.has_resource_properties(
        "AWS::EC2::SecurityGroup",
        {
            "GroupDescription": Match.any_value(),
            "VpcId": Match.any_value(),
            "SecurityGroupIngress": Match.any_value(),
            "SecurityGroupEgress": Match.any_value(),
        }
    )