def test_template(template: Template):
    # Assert DynamoDB table exists
    template.resource_count_is("AWS::DynamoDB::Table", 1)

    # Assert at least one local secondary index exists
    lsi_resources = template.find_resources("AWS::DynamoDB::Table", {
        "LocalSecondaryIndexes": Match.any_value()
    })
    assert len(lsi_resources) > 0, "Template must contain at least one local secondary index"

    # Assert at least one global secondary index exists
    gsi_resources = template.find_resources("AWS::DynamoDB::Table", {
        "GlobalSecondaryIndexes": Match.any_value()
    })
    assert len(gsi_resources) > 0, "Template must contain at least one global secondary index"