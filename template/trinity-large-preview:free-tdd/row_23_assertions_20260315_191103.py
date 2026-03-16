def test_template(template: Template):
    template.resource_count_is("AWS::DynamoDB::Table", 1)