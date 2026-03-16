def test_template(template: Template):
    # Assert exactly one Cognito User Pool exists
    template.resource_count_is("AWS::Cognito::UserPool", 1)

    # Assert the User Pool has admin-only user creation enabled
    template.has_resource_properties("AWS::Cognito::UserPool", {
        "AdminCreateUserConfig": {
            "AllowAdminCreateUserOnly": True
        }
    })

    # Assert the User Pool uses email for sign-in
    template.has_resource_properties("AWS::Cognito::UserPool", {
        "UsernameAttributes": ["email"]
    })

    # Assert the User Pool has email verification enabled
    template.has_resource_properties("AWS::Cognito::UserPool", {
        "VerificationMessageTemplate": {
            "EmailMessage": Match.string_like_regexp(".*"),
            "EmailSubject": Match.string_like_regexp(".*")
        }
    })

    # Assert the User Pool has policies configured
    template.has_resource_properties("AWS::Cognito::UserPool", {
        "Policies": {
            "PasswordPolicy": {
                "MinimumLength": Match.any_value(),
                "RequireLowercase": Match.any_value(),
                "RequireNumbers": Match.any_value(),
                "RequireSymbols": Match.any_value(),
                "RequireUppercase": Match.any_value()
            }
        }
    })