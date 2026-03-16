def test_template(template: Template):
    # Assert that exactly one EFS file system is created
    template.resource_count_is("AWS::EFS::FileSystem", 1)

    # Assert that the EFS file system has the required properties
    template.has_resource_properties("AWS::EFS::FileSystem", {
        "Encrypted": Match.any_value(),
        "PerformanceMode": Match.any_value(),
        "ThroughputMode": Match.any_value(),
        "LifecyclePolicies": Match.any_value()
    })