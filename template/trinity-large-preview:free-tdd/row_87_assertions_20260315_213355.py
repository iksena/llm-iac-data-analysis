def test_template(template: Template):
    # Assert S3 bucket exists
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert KMS key exists
    template.resource_count_is("AWS::KMS::Key", 1)

    # Assert KMS key alias exists
    template.resource_count_is("AWS::KMS::Alias", 1)

    # Assert KMS key has automatic rotation enabled
    template.has_resource_properties("AWS::KMS::Key", {
        "EnableKeyRotation": True
    })

    # Assert KMS key policy allows root account and imported role
    # We capture the key ID to verify it's referenced in the policy
    key_id = Capture()
    template.has_resource_properties("AWS::KMS::Key", {
        "KeyPolicy": {
            "Statement": Match.array_with(
                Match.object_like({
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": Match.array_with(
                            Match.string_like_regexp(r"arn:aws:iam::\d+:root")
                        )
                    },
                    "Action": Match.any_value(),
                    "Resource": key_id
                }),
                Match.object_like({
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": Match.any_value()  # imported role ARN
                    },
                    "Action": Match.any_value(),
                    "Resource": key_id
                })
            )
        }
    })

    # Assert KMS alias targets the KMS key
    template.has_resource_properties("AWS::KMS::Alias", {
        "TargetKeyId": key_id
    })