def test_template(template: Template):
    # Assert Glue Database exists
    template.has_resource_properties(
        "AWS::Glue::Database",
        {
            "DatabaseInput": {
                "Name": "cloudtrail_logs"
            }
        }
    )

    # Assert Glue Crawler exists
    template.has_resource_properties(
        "AWS::Glue::Crawler",
        {
            "Name": "cloudtrail_crawler",
            "DatabaseName": "cloudtrail_logs",
            "Targets": {
                "S3Targets": [
                    {
                        "Path": "s3://kk-admin/cloud-trail/AWSLogs/"
                    }
                ]
            },
            "TablePrefix": "cloudtrail_",
            "SchemaChangePolicy": {
                "UpdateBehavior": "UPDATE_IN_DATABASE",
                "DeleteBehavior": "DEPRECATE_IN_DATABASE"
            }
        }
    )

    # Assert exactly one Database and one Crawler
    template.resource_count_is("AWS::Glue::Database", 1)
    template.resource_count_is("AWS::Glue::Crawler", 1)