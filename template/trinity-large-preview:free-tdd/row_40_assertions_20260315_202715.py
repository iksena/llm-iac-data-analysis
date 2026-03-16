def test_template(template: Template):
    template.resource_count_is("AWS::SQS::Queue", 1)
    template.has_resource_properties("AWS::SQS::Queue", {
        "FifoQueue": True
    })