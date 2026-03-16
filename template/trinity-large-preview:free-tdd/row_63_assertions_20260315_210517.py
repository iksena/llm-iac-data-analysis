def test_template(template: Template):
    # Assert Aurora Cluster resource exists
    template.has_resource_properties(
        "AWS::RDS::DBCluster",
        {
            "Engine": "aurora-mysql",
            "EngineMode": "provisioned",
            "EngineVersion": Match.string_like_regexp(r"^\d+\.\d+\.\d+$"),
            "DBClusterParameterGroupName": Match.string_like_regexp(r".*"),
            "EnableCloudwatchLogsExports": ["error"],
            "DBSubnetGroupName": Match.string_like_regexp(r".*"),
            "VpcSecurityGroupIds": Match.array_with([Match.string_like_regexp(r".*")]),
            "Port": 3306,
            "MasterUsername": Match.string_like_regexp(r".*"),
            "MasterUserPassword": Match.string_like_regexp(r".*"),
            "BackupRetentionPeriod": 1,
            "PreferredBackupWindow": Match.string_like_regexp(r".*"),
            "PreferredMaintenanceWindow": Match.string_like_regexp(r".*"),
            "DeletionProtection": False,
            "EnableHttpEndpoint": False,
            "CopyTagsToSnapshot": False,
            "StorageEncrypted": False,
            "Iops": 0,
            "DBClusterIdentifier": Match.string_like_regexp(r".*"),
            "Tags": Match.array_with([Match.object_like({"Key": "Name"})]),
        }
    )

    # Assert two DB instances exist
    template.resource_count_is("AWS::RDS::DBInstance", 2)

    # Assert DB instances are publicly accessible and in correct subnet group
    template.has_resource_properties(
        "AWS::RDS::DBInstance",
        {
            "DBClusterIdentifier": Match.string_like_regexp(r".*"),
            "DBInstanceClass": "db.t3.large",
            "Engine": "aurora-mysql",
            "PubliclyAccessible": True,
            "DBSubnetGroupName": Match.string_like_regexp(r".*"),
            "DBParameterGroupName": Match.string_like_regexp(r".*"),
            "VPCSecurityGroups": Match.array_with([Match.string_like_regexp(r".*")]),
            "AvailabilityZone": Match.string_like_regexp(r".*"),
            "DBInstanceIdentifier": Match.string_like_regexp(r".*"),
            "Tags": Match.array_with([Match.object_like({"Key": "Name"})]),
        }
    )

    # Assert CloudWatch Logs integration is enabled
    template.has_resource_properties(
        "AWS::RDS::DBCluster",
        {
            "EnableCloudwatchLogsExports": ["error"]
        }
    )