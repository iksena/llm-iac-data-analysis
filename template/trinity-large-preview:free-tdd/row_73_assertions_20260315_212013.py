def test_template(template: Template):
    # Assert exactly one ECS Cluster resource exists
    template.resource_count_is("AWS::ECS::Cluster", 1)

    # Assert the ECS Cluster has the required capacity providers
    template.has_resource_properties("AWS::ECS::Cluster", {
        "CapacityProviders": Match.array_with(
            Match.string_like_regexp("FARGATE"),
            Match.string_like_regexp("FARGATE_SPOT")
        )
    })

    # Assert the ECS Cluster has default capacity provider strategy
    template.has_resource_properties("AWS::ECS::Cluster", {
        "DefaultCapacityProviderStrategy": Match.array_with(
            Match.object_like({
                "Base": 0,
                "Weight": 1,
                "CapacityProvider": Match.string_like_regexp("FARGATE")
            }),
            Match.object_like({
                "Base": 0,
                "Weight": 1,
                "CapacityProvider": Match.string_like_regexp("FARGATE_SPOT")
            })
        )
    })