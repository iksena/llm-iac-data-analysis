def test_template(template: Template):
    # EC2 Instance
    template.has_resource_properties(
        "AWS::EC2::Instance",
        {
            "ImageId": Match.string_like_regexp("ami-"),
            "InstanceType": Match.string_like_regexp("t3\.(nano|micro|small|medium|large)"),
            "IamInstanceProfile": Match.string_like_regexp(".*"),
            "UserData": Match.any_value(),
        }
    )

    # IAM Instance Profile
    template.has_resource_properties(
        "AWS::IAM::InstanceProfile",
        {
            "Roles": Match.array_with(Match.string_like_regexp(".*"))
        }
    )

    # IAM Role for SSM
    template.has_resource_properties(
        "AWS::IAM::Role",
        {
            "AssumeRolePolicyDocument": {
                "Statement": Match.array_with(
                    Match.object_like({
                        "Effect": "Allow",
                        "Principal": {"Service": "ec2.amazonaws.com"},
                        "Action": "sts:AssumeRole"
                    })
                )
            },
            "ManagedPolicyArns": Match.array_with(
                Match.string_like_regexp("arn:aws:iam::aws:policy/.*SSM.*")
            )
        }
    )

    # SSM Document
    template.has_resource_properties(
        "AWS::SSM::Document",
        {
            "DocumentType": "Command",
            "Content": Match.object_like({
                "schemaVersion": "1.0",
                "description": Match.any_value(),
                "parameters": Match.any_value(),
                "mainSteps": Match.any_value()
            })
        }
    )

    # IAM Role for FIS
    template.has_resource_properties(
        "AWS::IAM::Role",
        Match.object_like({
            "ManagedPolicyArns": Match.array_with(
                Match.string_like_regexp("arn:aws:iam::aws:policy/.*")
            ),
            "Policies": Match.any_value()
        })
    )

    # Parameters
    template.has_parameter("AMIId", {})
    template.has_parameter("InstanceType", {})
    template.has_parameter("SubnetId", {})

    # Resource counts
    template.resource_count_is("AWS::EC2::Instance", 1)
    template.resource_count_is("AWS::IAM::InstanceProfile", 1)
    template.resource_count_is("AWS::IAM::Role", 2)  # One for SSM, one for FIS
    template.resource_count_is("AWS::SSM::Document", 1)