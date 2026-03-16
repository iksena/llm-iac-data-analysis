def test_template(template: Template):
    # Assert S3 bucket for static website hosting
    template.resource_count_is("AWS::S3::Bucket", 1)
    template.has_resource_properties("AWS::S3::Bucket", {
        "WebsiteConfiguration": Match.object_like({
            "IndexDocument": "index.html",
            "ErrorDocument": "error.html"
        }),
        "AccessControl": "PublicRead"
    })

    # Assert Lambda function for slot machine logic
    template.resource_count_is("AWS::Lambda::Function", 1)
    template.has_resource_properties("AWS::Lambda::Function", {
        "Runtime": "nodejs*",
        "Handler": "index.handler",
        "Timeout": 10
    })

    # Assert Lambda execution IAM role with logging permissions
    template.resource_count_is("AWS::IAM::Role", 2)  # One for Lambda, one for Cognito
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": Match.object_like({
            "Statement": Match.array_with({
                "Principal": Match.object_like({
                    "Service": "lambda.amazonaws.com"
                })
            })
        }),
        "Policies": Match.array_with({
            "PolicyDocument": Match.object_like({
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Action": "logs:*"
                })
            })
        })
    })

    # Assert Cognito Identity Pool for anonymous access
    template.has_resource_properties("AWS::Cognito::IdentityPool", {
        "AllowUnauthenticatedIdentities": True
    })

    # Assert IAM role for Cognito unauthenticated identities
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": Match.object_like({
            "Statement": Match.array_with({
                "Principal": Match.object_like({
                    "Federated": "cognito-identity.amazonaws.com"
                }),
                "Condition": Match.object_like({
                    "StringEquals": {
                        "cognito-identity.amazonaws.com:aud": Capture()
                    }
                })
            })
        }),
        "Policies": Match.array_with({
            "PolicyDocument": Match.object_like({
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Action": "lambda:InvokeFunction"
                })
            })
        })
    })

    # Assert custom resource for automated deployment
    template.has_resource_properties("AWS::Lambda::Function", {
        "Handler": "index.handler",
        "Timeout": 300
    })

    # Assert Lambda invoke permission for Cognito role
    template.has_resource_properties("AWS::Lambda::Permission", {
        "Action": "lambda:InvokeFunction",
        "Principal": "cognito-identity.amazonaws.com"
    })

    # Assert S3 bucket policy for public read access
    template.has_resource_properties("AWS::S3::BucketPolicy", {
        "PolicyDocument": Match.object_like({
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Principal": "*",
                "Action": "s3:GetObject",
                "Resource": Match.string_like_regexp("arn:aws:s3:::.+/*")
            })
        })
    })