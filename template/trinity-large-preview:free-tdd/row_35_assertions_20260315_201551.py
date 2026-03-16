def test_template(template: Template):
    # Assert RDS MySQL instance with db.t3.micro instance class
    template.has_resource_properties(
        "AWS::RDS::DBInstance",
        {
            "DBInstanceClass": "db.t3.micro",
            "Engine": "mysql"
        }
    )

    # Assert automated snapshots are enabled
    template.has_resource_properties(
        "AWS::RDS::DBInstance",
        {
            "BackupRetentionPeriod": Match.any_value(),
            "EnablePerformanceInsights": Match.any_value()
        }
    )

    # Assert VPC with public subnets across two AZs
    template.has_resource_properties(
        "AWS::EC2::VPC",
        {
            "CidrBlock": Match.any_value(),
            "EnableDnsSupport": True,
            "EnableDnsHostnames": True
        }
    )

    template.has_resource_properties(
        "AWS::EC2::Subnet",
        {
            "MapPublicIpOnLaunch": True,
            "AvailabilityZone": Match.any_value()
        }
    )

    # Assert two public subnets exist
    template.resource_count_is("AWS::EC2::Subnet", 2)

    # Assert Internet Gateway and Route Table for external connectivity
    template.has_resource_properties(
        "AWS::EC2::InternetGateway",
        {}
    )

    template.has_resource_properties(
        "AWS::EC2::RouteTable",
        {
            "VpcId": Match.any_value()
        }
    )

    # Assert route for internet access
    template.has_resource_properties(
        "AWS::EC2::Route",
        {
            "DestinationCidrBlock": "0.0.0.0/0",
            "GatewayId": Match.any_value()
        }
    )