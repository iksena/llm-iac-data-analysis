def test_template(template: Template):
    # Assert table count
    template.resource_count_is("AWS::DynamoDB::Table", 2)

    # PROD table assertions
    prod_table_props = {
        "BillingMode": "PROVISIONED",
        "ProvisionedThroughput": {
            "ReadCapacityUnits": 20,
            "WriteCapacityUnits": 5
        },
        "SSESpecification": {
            "Enabled": True
        },
        "TimeToLiveSpecification": {
            "AttributeName": "expiryDate",
            "Enabled": True
        },
        "AutoScalingPolicy": Match.array_with({
            "PolicyName": Match.string_like_regexp(".*WriteCapacity.*"),
            "TargetTrackingScalingPolicyConfiguration": {
                "TargetValue": 70.0,
                "ScaleInCooldown": 60,
                "ScaleOutCooldown": 60,
                "PredefinedMetricSpecification": {
                    "PredefinedMetricType": "DynamoDBWriteCapacityUtilization"
                },
                "DisableScaleIn": False
            }
        })
    }
    template.has_resource_properties("AWS::DynamoDB::Table", Match.object_like(prod_table_props))

    # CODE table assertions
    code_table_props = {
        "BillingMode": "PAY_PER_REQUEST",
        "SSESpecification": {
            "Enabled": True
        },
        "TimeToLiveSpecification": {
            "AttributeName": "expiryDate",
            "Enabled": True
        }
    }
    template.has_resource_properties("AWS::DynamoDB::Table", Match.object_like(code_table_props))

    # Assert table names are dynamic
    tables = template.find_resources("AWS::DynamoDB::Table")
    for table_id, table_props in tables.items():
        table_name = table_props["Properties"]["TableName"]
        assert table_name.startswith("SupporterProductData-"), f"Table {table_id} has unexpected name: {table_name}"