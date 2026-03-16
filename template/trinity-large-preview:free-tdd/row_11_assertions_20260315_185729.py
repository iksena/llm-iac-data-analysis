def test_template(template: Template):
    # Assert DynamoDB table exists
    template.resource_count_is("AWS::DynamoDB::Table", 1)

    # Assert table properties
    template.has_resource_properties("AWS::DynamoDB::Table", {
        "BillingMode": "PAY_PER_REQUEST",
        "TimeToLiveSpecification": {
            "AttributeName": "ttl",
            "Enabled": True
        },
        "GlobalSecondaryIndexes": Match.array_with({
            "IndexName": "type-sentTime-index",
            "KeySchema": Match.array_with(
                {"AttributeName": "type", "KeyType": "HASH"},
                {"AttributeName": "sentTime", "KeyType": "RANGE"}
            )
        })
    })