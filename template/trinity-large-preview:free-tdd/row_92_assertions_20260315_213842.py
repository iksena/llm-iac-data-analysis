def test_template(template: Template):
    # Assert EC2 instance with SSM role
    template.has_resource_properties("AWS::EC2::Instance", {
        "IamInstanceProfile": Match.any_value(),
        "ImageId": Match.string_like_regexp("ami-.*"),
        "UserData": Match.any_value()  # UserData may contain script or SSM config
    })

    # Assert IAM Instance Profile and Role for SSM
    template.has_resource_properties("AWS::IAM::InstanceProfile", {
        "Roles": Match.array_with([Match.any_value()])
    })

    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": Match.object_like({
            "Statement": Match.array_with([{
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": {"Service": "ec2.amazonaws.com"}
            }])
        }),
        "ManagedPolicyArns": Match.array_with([
            Match.string_like_regexp("arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore")
        ])
    })

    # Assert SSM Association for Nginx installation
    template.has_resource_properties("AWS::SSM::Association", {
        "Name": "AWS-RunShellScript",
        "Targets": Match.array_with([{
            "Key": "InstanceIds",
            "Values": Match.array_with([Match.any_value()])
        }]),
        "Parameters": Match.object_like({
            "commands": Match.array_with([
                Match.string_like_regexp("sudo yum install -y nginx"),
                Match.string_like_regexp("sudo systemctl start nginx")
            ])
        })
    })

    # Assert S3 bucket for SSM logs
    template.has_resource_properties("AWS::S3::Bucket", {
        "BucketName": Match.any_value(),
        "Logging": Match.any_value()  # Ensure bucket is configured for logging
    })

    # Assert SSM Logging configuration
    template.has_resource_properties("AWS::SSM::Document", {
        "Name": "AWS-RunShellScript",
        "Content": Match.object_like({
            "schemaVersion": "1.2",
            "description": Match.any_value(),
            "parameters": Match.any_value(),
            "mainSteps": Match.array_with([{
                "action": "aws:runShellScript",
                "name": Match.any_value(),
                "inputs": Match.object_like({
                    "runCommand": Match.any_value()
                })
            }])
        })
    })

    # Assert SSM Logging configuration for S3
    template.has_resource_properties("AWS::SSM::Association", {
        "OutputLocation": Match.object_like({
            "S3Location": {
                "OutputS3BucketName": Match.any_value(),
                "OutputS3KeyPrefix": "logs/"
            }
        })
    })