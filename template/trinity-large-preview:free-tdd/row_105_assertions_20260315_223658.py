def test_template(template: Template):
    # Assert exactly one IAM Role is created
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert the IAM Role has the required trust policy for EC2 and SSM
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Principal": {
                    "Service": Match.array_with("ec2.amazonaws.com", "ssm.amazonaws.com")
                },
                "Action": "sts:AssumeRole"
            })
        }
    })

    # Assert the IAM Role has at least one policy attached (for cross-service automation)
    template.has_resource_properties("AWS::IAM::Role", {
        "Policies": Match.any_value
    })