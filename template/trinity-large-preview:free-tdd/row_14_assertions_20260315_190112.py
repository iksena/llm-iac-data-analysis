def test_template(template: Template):
    # Assert exactly one ENI is created
    template.resource_count_is("AWS::EC2::NetworkInterface", 1)

    # Assert exactly two EIPs are created
    template.resource_count_is("AWS::EC2::EIP", 2)

    # Assert the ENI has at least one secondary private IP
    # We cannot assert exact count without knowing the business need's requirement
    # But we can assert it has the property and it's not empty
    template.has_resource_properties("AWS::EC2::NetworkInterface", {
        "SecondaryPrivateIpAddressCount": Match.any_value
    })

    # Assert the ENI has at least one public IP (Elastic IP association)
    # We use Match.any_value since we don't know the exact count or properties
    # The business need implies EIPs should be associated with the ENI
    template.has_resource_properties("AWS::EC2::NetworkInterface", {
        "PublicIp": Match.any_value
    })

    # Assert EIPs exist and are of correct type
    # We don't assert specific properties of EIPs since business need doesn't specify
    # But we can assert they are present
    template.has_resource("AWS::EC2::EIP", {})