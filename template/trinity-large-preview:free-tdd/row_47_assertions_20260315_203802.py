def test_template(template: Template):
    # Assert exactly one IAM role is created
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert the IAM role has the correct trust relationship for EC2
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": [{
                "Effect": "Allow",
                "Principal": {"Service": "ec2.amazonaws.com"},
                "Action": "sts:AssumeRole"
            }]
        }
    })

    # Assert the IAM role has read-only IAM permissions
    template.has_resource_properties("AWS::IAM::Role", {
        "Policies": [{
            "PolicyDocument": {
                "Statement": [{
                    "Effect": "Allow",
                    "Action": [
                        "iam:Get*",
                        "iam:List*"
                    ],
                    "Resource": "*"
                }]
            }
        }]
    })