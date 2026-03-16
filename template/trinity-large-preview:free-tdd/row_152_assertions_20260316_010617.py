def test_template(template: Template):
    # VPC with private subnets across multiple AZs
    template.has_resource_properties("AWS::EC2::VPC", {
        "CidrBlock": Match.any_value(),
        "EnableDnsSupport": True,
        "EnableDnsHostnames": True
    })
    template.has_resource_properties("AWS::EC2::Subnet", {
        "AvailabilityZone": Match.any_value(),
        "VpcId": Match.any_value(),
        "CidrBlock": Match.any_value(),
        "MapPublicIpOnLaunch": False
    })
    template.resource_count_is("AWS::EC2::Subnet", Match.any_value())

    # Aurora MySQL cluster with primary and reader instances
    template.has_resource_properties("AWS::RDS::DBCluster", {
        "Engine": "aurora-mysql",
        "EngineMode": "provisioned",
        "StorageEncrypted": True,
        "EnableIAMDatabaseAuthentication": True,
        "EnableHttpEndpoint": True,
        "BackupRetentionPeriod": Match.any_value(),
        "DBSubnetGroupName": Match.any_value(),
        "VpcSecurityGroupIds": Match.any_value()
    })
    template.resource_count_is("AWS::RDS::DBCluster", 1)

    # RDS Proxy with TLS enforcement and connection pooling
    template.has_resource_properties("AWS::RDS::DBProxy", {
        "EngineFamily": "MYSQL",
        "Auth": Match.array_with([{
            "AuthScheme": "SECRETS",
            "IAMAuth": "DISABLED",
            "SecretArn": Match.any_value()
        }]),
        "RequireTLS": True,
        "VpcSecurityGroupIds": Match.any_value(),
        "VpcSubnetIds": Match.any_value(),
        "IdleClientTimeout": Match.any_value(),
        "MaxConnectionsPercent": Match.any_value()
    })
    template.resource_count_is("AWS::RDS::DBProxy", 1)

    # Security groups restricting access to authorized resources
    template.has_resource_properties("AWS::EC2::SecurityGroup", {
        "GroupDescription": Match.any_value(),
        "VpcId": Match.any_value(),
        "SecurityGroupIngress": Match.any_value(),
        "SecurityGroupEgress": Match.any_value()
    })
    template.resource_count_is("AWS::EC2::SecurityGroup", Match.any_value())

    # Secrets Manager for credential management
    template.has_resource_properties("AWS::SecretsManager::Secret", {
        "Name": Match.any_value(),
        "Description": Match.any_value(),
        "GenerateSecretString": Match.object_like({
            "SecretStringTemplate": Match.any_value(),
            "GenerateStringKey": "password",
            "PasswordLength": Match.any_value(),
            "ExcludeCharacters": Match.any_value()
        })
    })
    template.resource_count_is("AWS::SecretsManager::Secret", 1)

    # IAM role for RDS Proxy to retrieve secrets
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": Match.object_like({
            "Statement": Match.array_with([{
                "Effect": "Allow",
                "Principal": Match.object_like({
                    "Service": "rds.amazonaws.com"
                }),
                "Action": "sts:AssumeRole"
            }])
        }),
        "Policies": Match.any_value()
    })
    template.resource_count_is("AWS::IAM::Role", Match.any_value())

    # CloudWatch logging, enhanced monitoring, and performance insights
    template.has_resource_properties("AWS::RDS::DBCluster", {
        "EnableCloudwatchLogsExports": Match.array_with(["audit", "error", "general", "slowquery"]),
        "MonitoringInterval": Match.any_value(),
        "EnablePerformanceInsights": True
    })
    template.has_resource_properties("AWS::RDS::DBInstance", {
        "MonitoringInterval": Match.any_value(),
        "EnablePerformanceInsights": True
    })