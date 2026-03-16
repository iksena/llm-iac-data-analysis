def test_template(template: Template):
    # Assert exactly one Lambda function exists
    template.resource_count_is("AWS::Lambda::Function", 1)

    # Assert the Lambda function has the required Node.js 20.x runtime
    template.has_resource_properties("AWS::Lambda::Function", {
        "Runtime": "nodejs20.x"
    })