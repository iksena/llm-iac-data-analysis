def test_template(template: Template):
    # Assert S3 bucket exists
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert IAM Role exists
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert Glue Job exists
    template.resource_count_is("AWS::Glue::Job", 1)

    # Assert Glue Job has version 4.0
    template.has_resource_properties("AWS::Glue::Job", {
        "Command": {
            "Name": "glueetl",
            "PythonVersion": "3"
        },
        "DefaultArguments": {
            "--job-language": "python",
            "--pyspark-python": "/usr/bin/python3",
            "--pyspark-driver-python": "/usr/bin/python3"
        },
        "MaxCapacity": 2,
        "WorkerType": "G.1X",
        "Role": Capture(),
        "GlueVersion": "4.0"
    })

    # Assert IAM Role has required policies
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": [{
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": {
                    "Service": "glue.amazonaws.com"
                }
            }]
        },
        "ManagedPolicyArns": Match.array_with(
            "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
        ),
        "Policies": Match.array_with({
            "PolicyDocument": {
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Action": [
                        "s3:GetObject",
                        "s3:PutObject",
                        "s3:ListBucket"
                    ],
                    "Resource": Match.array_with(
                        Match.string_like_regexp("arn:aws:s3:::*")
                    )
                })
            }
        })
    })

    # Assert S3 bucket has proper versioning and encryption
    template.has_resource_properties("AWS::S3::Bucket", {
        "VersioningConfiguration": {
            "Status": "Enabled"
        },
        "BucketEncryption": {
            "ServerSideEncryptionConfiguration": [{
                "ServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }]
        }
    })