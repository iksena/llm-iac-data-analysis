def test_template(template: Template):
    template.resource_count_is("AWS::S3::Bucket", 1)