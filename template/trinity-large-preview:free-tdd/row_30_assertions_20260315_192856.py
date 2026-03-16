def test_template(template: Template):
    # EFS File System
    template.resource_count_is("AWS::EFS::FileSystem", 1)

    # VPC with public subnets
    template.resource_count_is("AWS::EC2::VPC", 1)
    template.resource_count_is("AWS::EC2::Subnet", 2)  # One per AZ
    template.resource_count_is("AWS::EC2::InternetGateway", 1)
    template.resource_count_is("AWS::EC2::VPCGatewayAttachment", 1)

    # EC2 Instances in separate AZs
    template.resource_count_is("AWS::EC2::Instance", 2)

    # IAM Role with EFS and SSM permissions
    template.resource_count_is("AWS::IAM::Role", 1)
    # Verify the role has the expected policies (EC2, SSM, EFS)
    role = template.find_resources("AWS::IAM::Role", {})
    if role:
        role_id = next(iter(role))
        role_props = role[role_id]["Properties"]
        assert "AssumeRolePolicyDocument" in role_props
        assert "Policies" in role_props
        policies = role_props["Policies"]
        policy_names = [p["PolicyName"] for p in policies]
        assert "AmazonSSMManagedInstanceCore" in policy_names
        assert "AmazonElasticFileSystemClientReadWriteAccess" in policy_names

    # CloudWatch Alarms for EFS monitoring
    template.resource_count_is("AWS::CloudWatch::Alarm", 2)
    alarms = template.find_resources("AWS::CloudWatch::Alarm", {})
    if alarms:
        alarm_names = [alarms[a]["Properties"]["AlarmName"] for a in alarms]
        assert any("EFS I/O Limit" in name for name in alarm_names)
        assert any("EFS Throughput" in name for name in alarm_names)

    # Security Groups for controlled NFS access
    template.resource_count_is("AWS::EC2::SecurityGroup", 2)  # One for EFS, one for EC2

    # Network ACLs
    template.resource_count_is("AWS::EC2::NetworkAcl", 1)
    template.resource_count_is("AWS::EC2::NetworkAclEntry", 4)  # Inbound/Outbound rules

    # Outputs for EFS and EC2 instance IDs
    template.has_output("EFSFileSystemId", Match.object_like({
        "Value": Match.string_like_regexp("fs-[a-zA-Z0-9]+")
    }))
    template.has_output("EC2InstanceIds", Match.object_like({
        "Value": Match.array_with(Match.string_like_regexp("i-[a-zA-Z0-9]+"))
    }))