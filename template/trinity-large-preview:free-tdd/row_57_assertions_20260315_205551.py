def test_template(template: Template):
    # Assert that exactly one ECS cluster is created
    template.resource_count_is("AWS::ECS::Cluster", 1)

    # Assert the ECS cluster has the expected properties
    # (no specific properties were mentioned in the business need,
    # so we only assert the resource exists and is of the correct type)
    template.has_resource_properties("AWS::ECS::Cluster", {})