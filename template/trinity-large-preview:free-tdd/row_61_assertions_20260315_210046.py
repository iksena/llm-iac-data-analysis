def test_template(template: Template):
    # Assert exactly one Route53 Hosted Zone resource exists
    template.resource_count_is("AWS::Route53::HostedZone", 1)

    # Assert the Hosted Zone has the correct domain name
    template.has_resource_properties("AWS::Route53::HostedZone", {
        "Name": "www.example.com"
    })

    # Assert the Hosted Zone is private and associated with a VPC
    template.has_resource_properties("AWS::Route53::HostedZone", {
        "HostedZoneConfig": {
            "Comment": Match.string_like_regexp(".*private.*")
        },
        "VPC": Match.any_value()
    })