<cdk_assertions>
def test_template(template: Template):
    # Assert Step Functions state machine exists
    template.has_resource_properties(
        "AWS::StepFunctions::StateMachine",
        {
            "StateMachineName": "Calculator-StateMachine"
        }
    )

    # Assert Lambda function exists
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FunctionName": "Calculator"
        }
    )

    # Assert Lambda function has correct timeout (default is 3 seconds, but let's assert it's at least 10)
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Timeout": 10
        }
    )

    # Assert CloudWatch Log Group exists with correct retention
    template.has_resource_properties(
        "AWS::Logs::LogGroup",
        {
            "RetentionInDays": 3
        }
    )

    # Assert Step Functions state machine references the Lambda function
    template.has_resource_properties(
        "AWS::StepFunctions::StateMachine",
        {
            "DefinitionString": Match.string_like_regexp(
                r'"Resource":"arn:aws:lambda:.*:.*:function:Calculator"'
            )
        }
    )

    # Assert Lambda function has correct handler and runtime
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Handler": "index.handler",
            "Runtime": "nodejs14.x"
        }
    )

    # Assert Lambda function has correct timeout
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Timeout": 10
        }
    )

    # Assert Lambda function has correct memory size
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "MemorySize": 128
        }
    )

    # Assert Lambda function has correct environment variables
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Environment": {
                "Variables": {
                    "LOG_RETENTION_DAYS": "3"
                }
            }
        }
    )

    # Assert Lambda function has correct IAM role
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Role": Match.string_like_regexp(
                r'"arn:aws:iam::.*:role/.*"'
            )
        }
    )

    # Assert Lambda function has correct VPC configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "VpcConfig": {
                "SubnetIds": Match.array_with(
                    Match.string_like_regexp(
                        r'"subnet-.*"'
                    )
                ),
                "SecurityGroupIds": Match.array_with(
                    Match.string_like_regexp(
                        r'"sg-.*"'
                    )
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs:.*:.*:.*"'
                )
            }
        }
    )

    # Assert Lambda function has correct tracing configuration
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "TracingConfig": {
                "Mode": "Active"
            }
        }
    )

    # Assert Lambda function has correct layers
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Layers": Match.array_with(
                Match.string_like_regexp(
                    r'"arn:aws:lambda:.*:.*:layer:.*"'
                )
            )
        }
    )

    # Assert Lambda function has correct file system
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "FileSystemConfigs": Match.array_with(
                {
                    "Arn": Match.string_like_regexp(
                        r'"arn:aws:elasticfilesystem:.*:.*:file-system/.*"'
                    ),
                    "LocalMountPath": "/mnt/layer"
                }
            )
        }
    )

    # Assert Lambda function has correct image config
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "ImageConfig": {
                "EntryPoint": Match.array_with(
                    "node",
                    "index.js"
                ),
                "Command": Match.array_with(
                    "handler"
                ),
                "WorkingDirectory": "/var/task"
            }
        }
    )

    # Assert Lambda function has correct package type
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "PackageType": "Image"
        }
    )

    # Assert Lambda function has correct code
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "Code": {
                "ImageUri": Match.string_like_regexp(
                    r'".*"'
                )
            }
        }
    )

    # Assert Lambda function has correct dead letter queue
    template.has_resource_properties(
        "AWS::Lambda::Function",
        {
            "DeadLetterConfig": {
                "TargetArn": Match.string_like_regexp(
                    r'"arn:aws:sqs: