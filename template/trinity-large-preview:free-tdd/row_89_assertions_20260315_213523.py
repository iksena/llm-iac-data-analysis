def test_template(template: Template):
    # Assert Security Hub resource is created
    template.resource_count_is("AWS::SecurityHub::Hub", 1)

    # Assert default standards are enabled
    template.has_resource_properties("AWS::SecurityHub::Hub", {
        "EnableDefaultStandards": True
    })

    # Assert consolidated control findings are enabled
    template.has_resource_properties("AWS::SecurityHub::Hub", {
        "ControlFindingGenerator": Match.array_with("STANDARD_CONTROL")
    })