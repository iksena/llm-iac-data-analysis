def test_template(template: Template):
    # DynamoDB table with streaming enabled
    template.resource_count_is("AWS::DynamoDB::Table", 1)
    template.has_resource_properties("AWS::DynamoDB::Table", {
        "StreamSpecification": {
            "StreamViewType": Match.string_like_regexp("NEW_AND_OLD_IMAGES|NEW_IMAGE|OLD_IMAGE")
        }
    })

    # EventBridge event bus
    template.resource_count_is("AWS::Events::EventBus", 1)
    template.has_resource_properties("AWS::Events::EventBus", {
        "Name": Match.string_like_regexp(".*")
    })

    # Two EventBridge Pipes (one for INSERT, one for MODIFY)
    template.resource_count_is("AWS::Events::Pipe", 2)
    pipes = template.find_resources("AWS::Events::Pipe")
    assert len(pipes) == 2

    # Verify each pipe has the expected source and target
    for pipe_id, pipe_props in pipes.items():
        # Source should be DynamoDB stream
        assert pipe_props["Properties"]["Source"]["Type"] == "DynamoDBStream"
        # Target should be the event bus
        assert pipe_props["Properties"]["Target"]["Type"] == "EventBus"
        # Each pipe should have a filter (INSERT or MODIFY)
        assert "Filter" in pipe_props["Properties"]