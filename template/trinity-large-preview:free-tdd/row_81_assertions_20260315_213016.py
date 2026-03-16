def test_template(template: Template):
    # Assert exactly one Resource Group is created
    template.resource_count_is("AWS::ResourceGroups::Group", 1)

    # Assert the Resource Group has tag-based filters
    template.has_resource_properties("AWS::ResourceGroups::Group", {
        "ResourceQuery": {
            "Type": "TAG_FILTERS_1_0",
            "Query": {
                "ResourceTypeFilters": Match.array_with(
                    Match.string_like_regexp("AWS::EC2::Instance"),
                    Match.string_like_regexp("AWS::RDS::DBInstance"),
                    Match.string_like_regexp("AWS::SageMaker::NotebookInstance"),
                    Match.string_like_regexp("AWS::SSM::Document")
                ),
                "TagFilters": Match.any_value()
            }
        }
    })