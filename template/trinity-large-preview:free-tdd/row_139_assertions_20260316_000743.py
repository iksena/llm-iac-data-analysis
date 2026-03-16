def test_template(template: Template):
    # Assert Lambda function exists
    template.resource_count_is("AWS::Lambda::Function", 1)

    # Assert custom resource exists
    template.resource_count_is("Custom::helper", 1)

    # Assert parameters exist
    template.has_parameter("FirstNumber", {})
    template.has_parameter("SecondNumber", {})
    template.has_parameter("Operator", {})
    template.has_parameter("SimulateFailure", {})

    # Assert outputs exist
    template.has_output("CalculationResult", {})
    template.has_output("CalculationStatus", {})

    # Assert Lambda function properties (basic required properties)
    template.has_resource_properties("AWS::Lambda::Function", {
        "Handler": Match.any_value(),
        "Runtime": Match.any_value(),
        "Code": Match.any_value()
    })

    # Assert custom resource properties
    template.has_resource_properties("Custom::helper", {
        "ServiceToken": Match.string_like_regexp("arn:aws:lambda.*"),
        "FirstNumber": Match.any_value(),
        "SecondNumber": Match.any_value(),
        "Operator": Match.any_value(),
        "SimulateFailure": Match.any_value()
    })