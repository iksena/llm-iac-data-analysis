def test_template(template: Template):
    # Auto Scaling Group
    template.has_resource_properties(
        "AWS::AutoScaling::AutoScalingGroup",
        {
            "VPCZoneIdentifier": Match.any_value(),
            "LaunchTemplate": Match.any_value(),
            "TargetGroupARNs": Match.any_value(),
        },
    )

    # Launch Template
    template.has_resource_properties(
        "AWS::EC2::LaunchTemplate",
        {
            "UserData": Match.any_value(),
        },
    )

    # Application Load Balancer
    template.has_resource_properties(
        "AWS::ElasticLoadBalancingV2::LoadBalancer",
        {
            "Scheme": "internet-facing",
            "Subnets": Match.any_value(),
        },
    )

    # Target Group
    template.has_resource_properties(
        "AWS::ElasticLoadBalancingV2::TargetGroup",
        {
            "Port": 80,
            "Protocol": "HTTP",
        },
    )

    # RDS MySQL Instance
    template.has_resource_properties(
        "AWS::RDS::DBInstance",
        {
            "Engine": "mysql",
            "DBName": Match.any_value(),
            "MasterUsername": Match.any_value(),
            "MasterUserPassword": Match.any_value(),
        },
    )

    # S3 Bucket for CodeDeploy artifacts
    template.has_resource_properties(
        "AWS::S3::Bucket",
        {},
    )

    # CodeDeploy Application
    template.has_resource_properties(
        "AWS::CodeDeploy::Application",
        {
            "ApplicationType": "server",
        },
    )

    # CodeDeploy Deployment Group
    template.has_resource_properties(
        "AWS::CodeDeploy::DeploymentGroup",
        {
            "ServiceRoleArn": Match.any_value(),
            "AutoScalingGroups": Match.any_value(),
            "DeploymentConfigName": Match.any_value(),
        },
    )

    # SSM Parameter for database credentials
    template.has_resource_properties(
        "AWS::SSM::Parameter",
        {
            "Type": "SecureString",
            "Value": Match.any_value(),
        },
    )

    # IAM Role for CodeDeploy
    template.has_resource_properties(
        "AWS::IAM::Role",
        {
            "AssumeRolePolicyDocument": Match.any_value(),
            "ManagedPolicyArns": Match.any_value(),
        },
    )

    # Count assertions
    template.resource_count_is("AWS::AutoScaling::AutoScalingGroup", 1)
    template.resource_count_is("AWS::EC2::LaunchTemplate", 1)
    template.resource_count_is("AWS::ElasticLoadBalancingV2::LoadBalancer", 1)
    template.resource_count_is("AWS::ElasticLoadBalancingV2::TargetGroup", 1)
    template.resource_count_is("AWS::RDS::DBInstance", 1)
    template.resource_count_is("AWS::S3::Bucket", 1)
    template.resource_count_is("AWS::CodeDeploy::Application", 1)
    template.resource_count_is("AWS::CodeDeploy::DeploymentGroup", 1)
    template.resource_count_is("AWS::SSM::Parameter", Match.any_value())
    template.resource_count_is("AWS::IAM::Role", Match.any_value())