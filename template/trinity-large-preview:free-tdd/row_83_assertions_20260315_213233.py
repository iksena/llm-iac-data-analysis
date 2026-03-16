def test_template(template: Template):
    # Assert Transit Gateway with specific BGP ASN and settings
    template.has_resource_properties(
        "AWS::EC2::TransitGateway",
        {
            "Options": {
                "AmazonSideAsn": 65000,
                "AutoAcceptSharedAttachments": "enable",
                "DefaultRouteTableAssociation": "enable",
                "DefaultRouteTablePropagation": "enable"
            }
        }
    )

    # Assert exactly one Transit Gateway
    template.resource_count_is("AWS::EC2::TransitGateway", 1)

    # Capture the Transit Gateway ID for use in the RAM resource share
    tgw_id = Capture()

    # Assert RAM Resource Share that shares the TGW with the specified account
    template.has_resource_properties(
        "AWS::RAM::ResourceShare",
        {
            "Resources": [tgw_id],
            "Principals": ["644519422710"]
        }
    )

    # Assert exactly one RAM Resource Share
    template.resource_count_is("AWS::RAM::ResourceShare", 1)

    # Assert Outputs for TGW ID and Resource Share ID
    template.has_output(
        "TransitGatewayId",
        {
            "Value": tgw_id
        }
    )

    resource_share_id = Capture()
    template.has_output(
        "ResourceShareId",
        {
            "Value": resource_share_id
        }
    )