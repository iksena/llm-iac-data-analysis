def test_template(template: Template):
    # EC2 Instance with SSM IAM Role
    template.resource_count_is("AWS::EC2::Instance", 1)
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": [{
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": {"Service": "ec2.amazonaws.com"}
            }]
        },
        "ManagedPolicyArns": Match.array_with(
            Match.string_like_regexp("arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore")
        )
    })

    # SSM Automation Document
    template.resource_count_is("AWS::SSM::Document", 1)
    template.has_resource_properties("AWS::SSM::Document", {
        "DocumentType": "Automation",
        "DocumentFormat": "YAML",
        "Content": Match.object_like({
            "mainSteps": Match.array_with(
                Match.object_like({
                    "action": "aws:runShellScript",
                    "inputs": Match.object_like({
                        "runCommand": Match.array_with(
                            Match.string_like_regexp("yum update -y"),
                            Match.string_like_regexp("amazon-linux-extras install nginx1 -y"),
                            Match.string_like_regexp("curl -f http://localhost")
                        )
                    })
                })
            )
        })
    })

    # S3 Bucket for Logs
    template.resource_count_is("AWS::S3::Bucket", 1)
    template.has_resource_properties("AWS::S3::Bucket", {
        "BucketName": Match.string_like_regexp(".*-logs")
    })

    # SSM Association for Automation Document
    template.resource_count_is("AWS::SSM::Association", 1)
    template.has_resource_properties("AWS::SSM::Association", {
        "Name": Capture(),
        "Targets": Match.array_with(
            Match.object_like({
                "Key": "InstanceIds",
                "Values": Match.array_with(Match.string_like_regexp("i-"))
            })
        )
    })