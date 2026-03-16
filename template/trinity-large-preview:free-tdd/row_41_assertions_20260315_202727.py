def test_template(template: Template):
    template.resource_count_is("AWS::SQS::Queue", 1)