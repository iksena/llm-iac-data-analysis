def test_template(template: Template):
    # Assert exactly one GuardDuty detector is created
    template.resource_count_is("AWS::GuardDuty::Detector", 1)

    # Assert the detector has the required properties
    template.has_resource_properties("AWS::GuardDuty::Detector", {
        "Enable": True
    })