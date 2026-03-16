def test_template(template: Template):
    # Assert exactly one ECS cluster is created
    template.resource_count_is("AWS::ECS::Cluster", 1)

    # Assert the cluster has the expected properties for Fargate
    template.has_resource_properties("AWS::ECS::Cluster", {
        "CapacityProviders": Match.array_with("FARGATE"),
        "DefaultCapacityProviderStrategy": Match.array_with({
            "CapacityProvider": "FARGATE",
            "Weight": 1
        })
    })