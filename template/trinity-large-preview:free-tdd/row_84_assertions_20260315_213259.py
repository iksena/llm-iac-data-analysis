def test_template(template: Template):
    # Assert exactly one Macie Session resource exists
    template.resource_count_is("AWS::Macie::Session", 1)

    # Assert the Macie Session resource has the expected properties
    # Note: The business need does not specify any particular properties,
    # so we only assert the resource exists with the correct type.
    # If specific properties were required (e.g., FindingPublishingFrequency),
    # they would be asserted here using Match.object_like.