def test_template(template: Template):
    # Assert exactly one EC2 instance is created
    template.resource_count_is("AWS::EC2::Instance", 1)

    # Assert the instance has the correct AMI property
    template.has_resource_properties("AWS::EC2::Instance", {
        "ImageId": Match.string_like_regexp("ami-.*")
    })