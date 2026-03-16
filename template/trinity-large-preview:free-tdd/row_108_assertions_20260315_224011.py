def test_template(template: Template):
    # Assert Cognito User Pool exists
    template.resource_count_is("AWS::Cognito::UserPool", 1)

    # Assert User Pool has email verification enabled
    template.has_resource_properties("AWS::Cognito::UserPool", {
        "EmailVerificationMessage": Match.any_value(),
        "EmailVerificationSubject": Match.any_value(),
        "EmailVerificationType": "Code"
    })

    # Assert User Pool has customizable password policy (at least one policy property)
    template.has_resource_properties("AWS::Cognito::UserPool", {
        "PasswordPolicy": Match.object_like({
            "MinimumLength": Match.any_value(),
            "RequireLowercase": Match.any_value(),
            "RequireNumbers": Match.any_value(),
            "RequireSymbols": Match.any_value(),
            "RequireUppercase": Match.any_value()
        })
    })

    # Assert User Pool has OAuth flows and supported auth methods
    template.has_resource_properties("AWS::Cognito::UserPool", {
        "AllowedOAuthFlows": Match.array_with("code", "implicit"),
        "AllowedOAuthScopes": Match.any_value(),
        "AllowedOAuthFlowsUserPoolClient": True,
        "CallbackURLs": Match.any_value(),
        "LogoutURLs": Match.any_value()
    })

    # Assert User Pool has a preconfigured domain for hosted login pages
    template.has_resource_properties("AWS::Cognito::UserPool", {
        "Domain": Match.any_value()
    })

    # Assert User Pool Client exists with supported auth methods
    template.resource_count_is("AWS::Cognito::UserPoolClient", 1)
    template.has_resource_properties("AWS::Cognito::UserPoolClient", {
        "AllowedOAuthFlows": Match.array_with("code", "implicit"),
        "AllowedOAuthScopes": Match.any_value(),
        "AllowedOAuthFlowsUserPoolClient": True,
        "CallbackURLs": Match.any_value(),
        "LogoutURLs": Match.any_value(),
        "EnableTokenRevocation": True,
        "RefreshTokenValidity": Match.any_value()
    })