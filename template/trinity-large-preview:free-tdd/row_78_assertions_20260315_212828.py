def test_template(template: Template):
    # Assert exactly one IPAM resource is created
    template.resource_count_is("AWS::EC2::IPAM", 1)

    # Assert the IPAM resource exists with required properties
    template.has_resource_properties("AWS::EC2::IPAM", {
        "Description": Match.any_value(),
        "OperatingRegions": Match.any_value()
    })

    # Assert outputs exist for critical identifiers
    template.has_output("IPAMArn", {
        "Value": Match.string_like_regexp(r"arn:aws:ec2:.*:.*:ipam/.*")
    })

    template.has_output("IPAMId", {
        "Value": Match.string_like_regexp(r"i-.*")
    })

    template.has_output("DefaultPublicScopeId", {
        "Value": Match.string_like_regexp(r"ipam-scope-.*")
    })

    template.has_output("DefaultPrivateScopeId", {
        "Value": Match.string_like_regexp(r"ipam-scope-.*")
    })