def test_template(template: Template):
    # Security Admins - full FIS access, role-passing, service-linked roles
    template.resource_count_is("AWS::IAM::Role", 4)
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Principal": {"Service": "fis.amazonaws.com"},
                "Action": "sts:AssumeRole"
            })
        },
        "Policies": Match.array_with({
            "PolicyDocument": {
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Action": "fis:*",
                    "Resource": "*"
                })
            }
        })
    })

    # Admins - FIS access with prod tag denial
    template.has_resource_properties("AWS::IAM::Role", {
        "Policies": Match.array_with({
            "PolicyDocument": {
                "Statement": Match.array_with({
                    "Effect": "Deny",
                    "Action": "fis:*",
                    "Resource": "*",
                    "Condition": {
                        "StringEquals": {
                            "aws:ResourceTag/Environment": "prod"
                        }
                    }
                })
            }
        })
    })

    # Users - limited FIS actions, tagging, no prod access
    template.has_resource_properties("AWS::IAM::Role", {
        "Policies": Match.array_with({
            "PolicyDocument": {
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Action": [
                        "fis:StartExperiment",
                        "fis:StopExperiment",
                        "fis:Get*",
                        "fis:List*",
                        "fis:TagResource"
                    ],
                    "Resource": "*"
                })
            }
        })
    })

    # Non-Users - read-only with explicit FIS denial
    template.has_resource_properties("AWS::IAM::Role", {
        "Policies": Match.array_with({
            "PolicyDocument": {
                "Statement": Match.array_with({
                    "Effect": "Deny",
                    "Action": "fis:*",
                    "Resource": "*"
                })
            }
        })
    })

    # All roles should have AWS ReadOnlyAccess managed policy
    template.has_resource_properties("AWS::IAM::Role", {
        "ManagedPolicyArns": Match.array_with(
            Match.string_like_regexp("arn:aws:iam::aws:policy/ReadOnlyAccess")
        )
    })

    # All roles should have conditional role-passing to FIS
    template.has_resource_properties("AWS::IAM::Role", {
        "Policies": Match.array_with({
            "PolicyDocument": {
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Action": "sts:PassRole",
                    "Resource": Match.string_like_regexp("arn:aws:iam::.*:role/.*")
                })
            }
        })
    })