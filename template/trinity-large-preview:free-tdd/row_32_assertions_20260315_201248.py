def test_template(template: Template):
    # Assert that exactly one Lambda function is created
    template.resource_count_is("AWS::Lambda::Function", 1)

    # Assert that the Lambda function has the required properties
    # (assuming the business need implies a basic Lambda function)
    template.has_resource_properties("AWS::Lambda::Function", {
        "Handler": Match.any_value(),
        "Runtime": Match.any_value(),
        "Code": Match.any_value(),
        "Role": Match.any_value()
    })