def test_template(template: Template):
    # Assert DynamoDB table resource exists
    template.resource_count_is("AWS::DynamoDB::Table", 1)

    # Capture the table resource for further assertions
    table = template.find_resources("AWS::DynamoDB::Table", {})

    # Assert the table has the required attributes
    template.has_resource_properties("AWS::DynamoDB::Table", {
        "AttributeDefinitions": Match.array_with(
            Match.object_like({"AttributeName": "ArtistId"}),
            Match.object_like({"AttributeName": "Concert"}),
            Match.object_like({"AttributeName": "TicketSales"})
        )
    })