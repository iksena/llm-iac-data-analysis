def test_template(template: Template):
    # EFS File System
    template.resource_count_is("AWS::EFS::FileSystem", 1)
    template.has_resource_properties("AWS::EFS::FileSystem", {
        "Encrypted": True
    })

    # EFS Mount Targets in two public subnets
    template.resource_count_is("AWS::EFS::MountTarget", 2)
    template.has_resource_properties("AWS::EFS::MountTarget", {
        "SecurityGroups": Match.array_with(Match.any_value())
    })

    # Two EC2 instances in separate AZs
    template.resource_count_is("AWS::EC2::Instance", 2)
    template.has_resource_properties("AWS::EC2::Instance", {
        "BlockDeviceMappings": Match.array_with({
            "DeviceName": "/dev/xvda",
            "Ebs": Match.object_like({
                "VolumeSize": 8
            })
        })
    })

    # IAM Role with EFS and SSM permissions
    template.resource_count_is("AWS::IAM::Role", 1)
    template.has_resource_properties("AWS::IAM::Role", {
        "ManagedPolicyArns": Match.array_with(
            Match.string_like_regexp("arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore")
        )
    })

    # CloudWatch Alarms for EFS performance metrics
    template.resource_count_is("AWS::CloudWatch::Alarm", Match.any_value())
    template.has_resource_properties("AWS::CloudWatch::Alarm", {
        "Namespace": "AWS/EFS",
        "MetricName": Match.any_value()
    })

    # Output for EFS file system ID
    template.has_output("EFSFileSystemId", {
        "Value": Match.string_like_regexp("fs-[a-zA-Z0-9]+")
    })