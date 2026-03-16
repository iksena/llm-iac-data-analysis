def test_template(template: Template):
    # IAM Role and Instance Profile for SSM and Image Builder
    template.has_resource_properties(
        "AWS::IAM::Role",
        {
            "AssumeRolePolicyDocument": {
                "Statement": [
                    {
                        "Action": "sts:AssumeRole",
                        "Effect": "Allow",
                        "Principal": {
                            "Service": "ec2.amazonaws.com"
                        }
                    }
                ],
                "Version": "2012-10-17"
            },
            "ManagedPolicyArns": [
                {
                    "Fn::Join": [
                        "",
                        [
                            "arn:",
                            {
                                "Ref": "AWS::Partition"
                            },
                            ":iam::aws:policy/service-role/AmazonSSMManagedInstanceCore"
                        ]
                    ]
                }
            ]
        }
    )

    template.has_resource_properties(
        "AWS::IAM::InstanceProfile",
        {
            "Roles": [
                {
                    "Ref": "IAMRole"  # Assuming logical ID is IAMRole
                }
            ]
        }
    )

    # S3 Bucket for Image Builder logs with public access disabled and owner tag
    template.has_resource_properties(
        "AWS::S3::Bucket",
        {
            "PublicAccessBlockConfiguration": {
                "BlockPublicAcls": True,
                "BlockPublicPolicy": True,
                "IgnorePublicAcls": True,
                "RestrictPublicBuckets": True
            },
            "Tags": [
                {
                    "Key": "owner",
                    "Value": "u12345678@anu.edu.au"
                }
            ]
        }
    )

    # Managed IAM Policy for S3 read/write access to logs bucket
    template.has_resource_properties(
        "AWS::IAM::Policy",
        {
            "PolicyDocument": {
                "Statement": [
                    {
                        "Action": [
                            "s3:GetObject",
                            "s3:PutObject",
                            "s3:ListBucket"
                        ],
                        "Effect": "Allow",
                        "Resource": [
                            {
                                "Fn::Join": [
                                    "",
                                    [
                                        "arn:",
                                        {
                                            "Ref": "AWS::Partition"
                                        },
                                        ":s3:::",
                                        {
                                            "Ref": "S3Bucket"  # Assuming logical ID is S3Bucket
                                        }
                                    ]
                                ]
                            },
                            {
                                "Fn::Join": [
                                    "",
                                    [
                                        "arn:",
                                        {
                                            "Ref": "AWS::Partition"
                                        },
                                        ":s3:::",
                                        {
                                            "Ref": "S3Bucket"
                                        },
                                        "/*"
                                    ]
                                ]
                            }
                        ]
                    }
                ],
                "Version": "2012-10-17"
            }
        }
    )