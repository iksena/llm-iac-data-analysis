def test_template(template: Template):
    # Assert Lambda function exists
    template.resource_count_is("AWS::Lambda::Function", 1)

    # Assert AppSync GraphQL API exists with API_KEY auth
    template.has_resource_properties("AWS::AppSync::GraphQLApi", {
        "Name": "PetShopAPI",
        "AuthenticationType": "API_KEY"
    })

    # Assert Lambda execution role exists
    template.resource_count_is("AWS::IAM::Role", 2)  # One for Lambda, one for AppSync

    # Assert AppSync DataSource linked to Lambda
    template.has_resource_properties("AWS::AppSync::DataSource", {
        "Type": "AWS_LAMBDA",
        "ServiceRoleArn": Match.string_like_regexp("arn:aws:iam::.*:role/.*")
    })

    # Assert AppSync Resolver for getPets query
    template.has_resource_properties("AWS::AppSync::Resolver", {
        "TypeName": "Query",
        "FieldName": "getPets"
    })

    # Assert Lambda function has IAM permission to be invoked by AppSync
    template.has_resource_properties("AWS::Lambda::Permission", {
        "Principal": "appsync.amazonaws.com"
    })