def test_template(template: Template):
    # Assert IAM role creation
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert the role has the expected IAM managed policies
    template.has_resource_properties("AWS::IAM::Role", {
        "ManagedPolicyArns": Match.array_with([
            Match.string_like_regexp("arn:aws:iam::aws:policy/AdministratorAccess")
        ])
    })

    # Assert the role has a permissions boundary property
    template.has_resource_properties("AWS::IAM::Role", {
        "PermissionsBoundary": Match.any_value()
    })

    # Assert the role has the expected tags
    template.has_resource_properties("AWS::IAM::Role", {
        "Tags": Match.array_with([
            Match.object_like({
                "Key": "Owner",
                "Value": Match.any_value()
            })
        ])
    })

    # Assert the role has the expected assume role policy
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": Match.object_like({
            "Version": "2012-10-17",
            "Statement": Match.array_with([
                Match.object_like({
                    "Effect": "Allow",
                    "Principal": Match.object_like({
                        "AWS": Match.any_value()
                    }),
                    "Action": "sts:AssumeRole"
                })
            ])
        })
    })

    # Assert the presence of the toggle parameter
    template.has_parameter("EnableStrictBoundaryEnforcement", {
        "Type": "String",
        "Default": "true"
    })

    # Assert the presence of the permission boundary policy
    template.has_resource("AWS::IAM::ManagedPolicy", {
        "Properties": Match.object_like({
            "PolicyDocument": Match.object_like({
                "Version": "2012-10-17",
                "Statement": Match.array_with([
                    Match.object_like({
                        "Effect": "Allow",
                        "Action": Match.array_with([
                            "s3:*",
                            "iam:Get*",
                            "iam:List*"
                        ]),
                        "Resource": "*"
                    })
                ])
            })
        })
    })

    # Assert the presence of the IAM policy for developers
    template.has_resource("AWS::IAM::Policy", {
        "Properties": Match.object_like({
            "PolicyDocument": Match.object_like({
                "Version": "2012-10-17",
                "Statement": Match.array_with([
                    Match.object_like({
                        "Effect": "Allow",
                        "Action": [
                            "iam:CreateRole",
                            "iam:DeleteRole",
                            "iam:AttachRolePolicy",
                            "iam:DetachRolePolicy",
                            "iam:PassRole",
                            "iam:GetRole",
                            "iam:ListRoles",
                            "iam:CreatePolicy",
                            "iam:DeletePolicy",
                            "iam:CreatePolicyVersion",
                            "iam:GetPolicy",
                            "iam:ListPolicies"
                        ],
                        "Resource": "*"
                    })
                ])
            })
        })
    })