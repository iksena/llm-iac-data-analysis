def test_template(template: Template):
    # Assert exactly one EC2 instance is created
    template.resource_count_is("AWS::EC2::Instance", 1)

    # Assert exactly one Security Group is created
    template.resource_count_is("AWS::EC2::SecurityGroup", 1)

    # Assert the EC2 instance has a SecurityGroup property referencing a SecurityGroup
    template.has_resource_properties("AWS::EC2::Instance", {
        "SecurityGroupIds": Match.array_with(Match.string_like_regexp(r"sg-[a-f0-9]+"))
    })

    # Assert the SecurityGroup has a GroupDescription property (common required property)
    template.has_resource_properties("AWS::EC2::SecurityGroup", {
        "GroupDescription": Match.any_value()
    })