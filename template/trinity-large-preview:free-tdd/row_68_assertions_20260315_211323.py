def test_template(template: Template):
    # Assert IAM Role exists
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert Instance Profile exists
    template.resource_count_is("AWS::IAM::InstanceProfile", 1)

    # Assert AWS managed policies are attached
    # CloudWatchAgentServerPolicy and AmazonSSMManagedInstanceCore are required
    template.has_resource_properties("AWS::IAM::Role", {
        "ManagedPolicyArns": Match.array_with(
            Match.string_like_regexp("arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"),
            Match.string_like_regexp("arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore")
        )
    })

    # Assert Instance Profile references the Role
    template.has_resource_properties("AWS::IAM::InstanceProfile", {
        "Roles": Match.array_with(
            Match.object_like({
                "Ref": Capture()
            })
        )
    })