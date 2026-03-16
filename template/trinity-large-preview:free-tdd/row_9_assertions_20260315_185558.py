def test_template(template: Template):
    # Assert exactly one EFS file system resource exists
    template.resource_count_is("AWS::EFS::FileSystem", 1)

    # Assert the file system has the required properties
    template.has_resource_properties("AWS::EFS::FileSystem", {
        "Encrypted": True,
        "LifecyclePolicies": Match.array_with({
            "TransitionToIA": "AFTER_30_DAYS"
        }),
        "ProvisionedThroughputInMibps": Match.any_value,
        "ThroughputMode": "provisioned",
        "AvailabilityZoneName": "us-east-1a"
    })

    # Assert the file system has a lifecycle policy for IA storage
    template.has_resource_properties("AWS::EFS::FileSystem", {
        "LifecyclePolicies": Match.array_with({
            "TransitionToIA": "AFTER_30_DAYS"
        })
    })

    # Assert the file system has a mount target in the correct AZ
    template.resource_count_is("AWS::EFS::MountTarget", 1)
    template.has_resource_properties("AWS::EFS::MountTarget", {
        "AvailabilityZoneId": "use1-az1",
        "FileSystemId": Capture(),
        "SubnetId": Match.any_value
    })