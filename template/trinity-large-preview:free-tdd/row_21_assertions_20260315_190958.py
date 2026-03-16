def test_template(template: Template):
    # Assert the Timestream database exists
    template.resource_count_is("AWS::Timestream::Database", 1)

    # Assert the four required tables exist
    template.resource_count_is("AWS::Timestream::Table", 4)

    # Assert specific table names exist (using regex to match exact names)
    template.has_resource_properties("AWS::Timestream::Table", {
        "TableName": Match.string_like_regexp("poc-table-01-batch-write")
    })
    template.has_resource_properties("AWS::Timestream::Table", {
        "TableName": Match.string_like_regexp("poc-table-02-older-records-memonly")
    })
    template.has_resource_properties("AWS::Timestream::Table", {
        "TableName": Match.string_like_regexp("poc-table-03-older-records-magnetic")
    })
    template.has_resource_properties("AWS::Timestream::Table", {
        "TableName": Match.string_like_regexp("poc-table-04-common-attributes")
    })