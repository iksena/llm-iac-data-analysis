def test_template(template: Template):
    # Assert exactly one KMS Key is created
    template.resource_count_is("AWS::KMS::Key", 1)

    # Assert the KMS Key has an Alias
    template.has_resource_properties("AWS::KMS::Alias", {
        "AliasName": Match.string_like_regexp("^alias/")
    })

    # Assert the KMS Key has a KeyId (captured for potential further assertions)
    key_id = Capture()
    template.has_resource_properties("AWS::KMS::Key", {
        "KeyId": key_id
    })