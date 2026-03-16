def test_template(template: Template):
    # Assert Aurora MySQL cluster with two db.t3.large instances
    template.resource_count_is("AWS::RDS::DBCluster", 1)
    template.resource_count_is("AWS::RDS::DBInstance", 2)

    # Assert instance type and engine
    template.has_resource_properties("AWS::RDS::DBInstance", {
        "DBInstanceClass": "db.t3.large",
        "Engine": "aurora-mysql"
    })

    # Assert cluster properties
    template.has_resource_properties("AWS::RDS::DBCluster", {
        "EngineMode": "provisioned",
        "Engine": "aurora-mysql",
        "DBClusterParameterGroupName": Match.any_value(),
        "MasterUsername": Match.any_value(),
        "MasterUserPassword": Match.any_value()
    })

    # Assert parameter groups exist (one for cluster, one for instances)
    template.resource_count_is("AWS::RDS::DBClusterParameterGroup", 1)
    template.resource_count_is("AWS::RDS::DBParameterGroup", 1)

    # Assert parameter group settings for time_zone and sql_mode
    template.has_resource_properties("AWS::RDS::DBClusterParameterGroup", {
        "Parameters": {
            "time_zone": Match.any_value(),
            "sql_mode": Match.any_value()
        }
    })

    template.has_resource_properties("AWS::RDS::DBParameterGroup", {
        "Parameters": {
            "time_zone": Match.any_value(),
            "sql_mode": Match.any_value()
        }
    })

    # Assert publicly accessible
    template.has_resource_properties("AWS::RDS::DBInstance", {
        "PubliclyAccessible": True
    })