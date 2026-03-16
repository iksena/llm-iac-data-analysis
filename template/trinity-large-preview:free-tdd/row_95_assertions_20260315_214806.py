def test_template(template: Template):
    # Assert EC2 instance with SSM role and tag
    template.has_resource_properties("AWS::EC2::Instance", {
        "ImageId": Match.string_like_regexp("ami-.*"),
        "IamInstanceProfile": Match.any_value(),
        "Tags": Match.array_with({
            "Key": "nginx",
            "Value": "Yes"
        })
    })

    # Assert IAM role for SSM
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": Match.array_with({
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                }
            })
        },
        "ManagedPolicyArns": Match.array_with(
            Match.string_like_regexp("arn:aws:iam::aws:policy/.*SSM.*")
        )
    })

    # Assert SSM Automation Document
    template.has_resource_properties("AWS::SSM::AutomationDocument", {
        "DocumentType": "Automation",
        "Content": {
            "schemaVersion": "0.3",
            "description": Match.any_value(),
            "parameters": Match.any_value(),
            "mainSteps": Match.array_with(
                Match.object_like({
                    "name": "UpdateOS",
                    "action": "aws:runShellScript",
                    "inputs": Match.object_like({
                        "runCommand": Match.array_with(
                            Match.string_like_regexp("sudo yum update -y")
                        )
                    })
                }),
                Match.object_like({
                    "name": "InstallNginx",
                    "action": "aws:runShellScript",
                    "inputs": Match.object_like({
                        "runCommand": Match.array_with(
                            Match.string_like_regexp("sudo yum install -y nginx")
                        )
                    })
                }),
                Match.object_like({
                    "name": "ValidateNginx",
                    "action": "aws:runShellScript",
                    "inputs": Match.object_like({
                        "runCommand": Match.array_like([
                            Match.string_like_regexp("sudo systemctl start nginx"),
                            Match.string_like_regexp("curl -f http://localhost")
                        ])
                    })
                })
            )
        }
    })

    # Assert SSM Document targets instances with nginx:Yes tag
    template.has_resource_properties("AWS::SSM::AutomationDocument", {
        "Content": {
            "mainSteps": Match.array_with({
                "targets": Match.array_with({
                    "Key": "tag:nginx",
                    "Values": ["Yes"]
                })
            })
        }
    })