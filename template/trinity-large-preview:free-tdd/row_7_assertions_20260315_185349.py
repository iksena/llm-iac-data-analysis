def test_template(template: Template):
    # Assert EC2 instance exists
    template.resource_count_is("AWS::EC2::Instance", 1)

    # Assert instance has the correct instance type
    template.has_resource_properties("AWS::EC2::Instance", {
        "InstanceType": "t3.micro"
    })

    # Assert instance has a security group attached
    template.has_resource_properties("AWS::EC2::Instance", {
        "SecurityGroupIds": Match.array_with(Match.any_value())
    })

    # Assert instance has SSM access (IAM role with SSM policy)
    template.has_resource_properties("AWS::EC2::Instance", {
        "IamInstanceProfile": Match.any_value()
    })

    # Assert SSM-managed instance (SSM agent installed)
    template.has_resource_properties("AWS::EC2::Instance", {
        "UserData": Match.string_like_regexp("amazon-ssm-agent")
    })

    # Assert region-specific AMI is used
    template.has_resource_properties("AWS::EC2::Instance", {
        "ImageId": Match.string_like_regexp("ami-")
    })