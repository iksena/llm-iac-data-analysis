def test_template(template: Template):
    # VPC with subnet
    template.has_resource_properties("AWS::EC2::VPC", {
        "CidrBlock": Match.any_value()
    })
    template.has_resource_properties("AWS::EC2::Subnet", {
        "VpcId": Match.any_value()
    })

    # S3 bucket
    template.has_resource_properties("AWS::S3::Bucket", {
        "BucketName": Match.any_value()
    })

    # Batch compute environment (EC2-based)
    template.has_resource_properties("AWS::Batch::ComputeEnvironment", {
        "Type": "MANAGED",
        "ComputeResources": {
            "Type": "EC2",
            "InstanceTypes": Match.array_with("m5.large"),
            "MinvCpus": Match.any_value(),
            "MaxvCpus": Match.any_value(),
            "DesiredvCpus": Match.any_value()
        }
    })

    # Job queue
    template.has_resource_properties("AWS::Batch::JobQueue", {
        "ComputeEnvironmentOrder": Match.array_with({
            "ComputeEnvironment": Match.any_value(),
            "Order": 1
        })
    })

    # Job definition
    template.has_resource_properties("AWS::Batch::JobDefinition", {
        "Type": "container",
        "ContainerProperties": {
            "Image": "amazonlinux",
            "Command": Match.array_with(
                "yum", "install", "-y", "aws-cli",
                "aws", "s3", "cp", Match.any_value(),
                "aws", "s3", "cp", Match.any_value(), Match.any_value()
            )
        }
    })