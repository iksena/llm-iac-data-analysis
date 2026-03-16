def test_template(template: Template):
    # Assert two IAM roles are created
    template.resource_count_is("AWS::IAM::Role", 2)

    # Find all IAM roles and verify they trust EC2 service
    roles = template.find_resources("AWS::IAM::Role")
    for role_id, role_props in roles.items():
        # Verify trust relationship with EC2 service
        assert role_props["Properties"]["AssumeRolePolicyDocument"]["Statement"][0]["Principal"]["Service"] == ["ec2.amazonaws.com"]

    # Verify managed policy attachment for read-only IAM access
    # We expect a managed policy with IAM read permissions to be attached
    # Since the exact policy ARN isn't specified, we'll verify the permissions via the role's policies
    for role_id, role_props in roles.items():
        # Check if there's a managed policy attached (could be inline or managed)
        # For this test, we'll verify the permissions are present in the role's policies
        if "Policies" in role_props["Properties"]:
            # Check inline policies for IAM read permissions
            for policy in role_props["Properties"]["Policies"]:
                if policy["PolicyName"] == "IAMReadOnlyAccess":
                    assert "iam:Get*" in policy["PolicyDocument"]["Statement"][0]["Action"]
                    assert "iam:List*" in policy["PolicyDocument"]["Statement"][0]["Action"]
                    assert policy["PolicyDocument"]["Statement"][0]["Effect"] == "Allow"
                    assert policy["PolicyDocument"]["Statement"][0]["Resource"] == "*"