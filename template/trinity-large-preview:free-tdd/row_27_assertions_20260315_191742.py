def test_template(template: Template):
    # Assert Kinesis Data Stream exists
    template.resource_count_is("AWS::Kinesis::Stream", 1)

    # Assert Kinesis Data Firehose exists
    template.resource_count_is("AWS::KinesisFirehose::DeliveryStream", 1)

    # Assert S3 bucket exists
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert Firehose delivery stream references the S3 bucket
    template.has_resource_properties("AWS::KinesisFirehose::DeliveryStream", {
        "Destination": "S3",
        "S3Configuration": {
            "BucketARN": Match.string_like_regexp("arn:aws:s3:::*")
        }
    })

    # Assert Kinesis Data Stream is referenced by Firehose
    template.has_resource_properties("AWS::KinesisFirehose::DeliveryStream", {
        "KinesisStreamSourceConfiguration": {
            "KinesisStreamARN": Match.string_like_regexp("arn:aws:kinesis:*:*:stream/*")
        }
    })