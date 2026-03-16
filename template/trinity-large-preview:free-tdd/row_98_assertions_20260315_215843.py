def test_template(template: Template):
    # Assert Amplify App exists
    template.resource_count_is("AWS::Amplify::App", 1)

    # Assert Amplify App has a production branch
    template.has_resource_properties("AWS::Amplify::Branch", {
        "BranchName": "production",
        "AppName": Capture()
    })

    # Assert Amplify App has an AppId output
    template.has_output("AppId", {
        "Value": Match.string_like_regexp(r"app-[a-zA-Z0-9-]+")
    })

    # Assert Amplify App has a DefaultDomain output
    template.has_output("DefaultDomain", {
        "Value": Match.string_like_regexp(r"[a-zA-Z0-9-]+.amplifyapp.com")
    })