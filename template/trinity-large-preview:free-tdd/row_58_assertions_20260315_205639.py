def test_template(template: Template):
    # Assert EFS file system creation
    template.resource_count_is("AWS::EFS::FileSystem", 1)

    # Assert VPC integration (EFS mount targets)
    template.resource_count_is("AWS::EFS::MountTarget", Match.any_value())

    # Assert CloudWatch alarms for performance monitoring
    template.resource_count_is("AWS::CloudWatch::Alarm", Match.any_value())

    # Assert AWS Backup vault creation
    template.resource_count_is("AWS::Backup::BackupVault", 1)

    # Assert AWS Backup plan creation
    template.resource_count_is("AWS::Backup::BackupPlan", 1)

    # Assert AWS Backup selection for EFS
    template.resource_count_is("AWS::Backup::BackupSelection", 1)

    # Assert conditional backup schedule parameter
    template.has_parameter("EnableAutomatedBackups", {
        "Type": "String",
        "AllowedValues": ["true", "false"],
        "Default": "true"
    })

    # Assert backup schedule parameter
    template.has_parameter("BackupSchedule", {
        "Type": "String",
        "Default": "cron(0 0 * * ? *)"
    })

    # Assert backup vault resource properties
    template.has_resource_properties("AWS::Backup::BackupVault", {
        "BackupVaultName": Match.string_like_regexp(".*-backup-vault")
    })

    # Assert backup plan resource properties
    template.has_resource_properties("AWS::Backup::BackupPlan", {
        "BackupPlan": Match.object_like({
            "Rules": Match.array_with([Match.object_like({
                "ScheduleExpression": Match.string_like_regexp("cron.*")
            })])
        })
    })

    # Assert EFS file system properties (basic required properties)
    template.has_resource_properties("AWS::EFS::FileSystem", {
        "Encrypted": Match.any_value(),
        "PerformanceMode": Match.any_value(),
        "ThroughputMode": Match.any_value()
    })