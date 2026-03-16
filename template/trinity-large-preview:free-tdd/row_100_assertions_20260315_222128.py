def test_template(template: Template):
    # Assert IAM groups and roles exist
    template.resource_count_is("AWS::IAM::Group", 3)
    template.resource_count_is("AWS::IAM::Role", 3)

    # Assert PrivilegedAdmin role with MFA requirement
    template.has_resource_properties("AWS::IAM::Role", {
        "RoleName": "PrivilegedAdmin",
        "Policies": Match.array_with({
            "PolicyDocument": Match.object_like({
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Action": "sts:AssumeRole",
                    "Condition": Match.object_like({
                        "Bool": {"aws:MultiFactorAuthPresent": True}
                    })
                })
            })
        })
    })

    # Assert cross-account trust relationships
    template.has_resource_properties("AWS::IAM::Role", {
        "RoleName": "RestrictedAdmin",
        "Policies": Match.array_with({
            "PolicyDocument": Match.object_like({
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Action": "sts:AssumeRole",
                    "Principal": Match.object_like({
                        "AWS": Match.string_like_regexp(r"arn:aws:iam::\d{12}:root")
                    })
                })
            })
        })
    })

    # Assert deny policies for sensitive operations
    template.has_resource_properties("AWS::IAM::Role", {
        "RoleName": "IdentityAdmin",
        "Policies": Match.array_with({
            "PolicyDocument": Match.object_like({
                "Statement": Match.array_with({
                    "Effect": "Deny",
                    "Action": Match.array_with("aws-portal:*", "cloudhsm:*")
                })
            })
        })
    })

    # Assert CloudFormation execution roles
    template.resource_count_is("AWS::IAM::Role", 2, Match.object_like({
        "Policies": Match.array_with({
            "PolicyDocument": Match.object_like({
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Action": Match.array_with("cloudformation:*", "cloudformation:CreateStackSet")
                })
            })
        })
    }))