def test_template(template: Template):
    # Assert S3 bucket with public read access via OAI
    template.has_resource_properties("AWS::S3::Bucket", {
        "AccessControl": "Private",
        "PublicAccessBlockConfiguration": {
            "BlockPublicAcls": True,
            "IgnorePublicAcls": True,
            "BlockPublicPolicy": True,
            "RestrictPublicBuckets": True
        }
    })

    # Assert CloudFront distribution with HTTPS enforcement and caching disabled
    template.has_resource_properties("AWS::CloudFront::Distribution", {
        "DistributionConfig": {
            "ViewerCertificate": {
                "SSLSupportMethod": "sni-only",
                "MinimumProtocolVersion": "TLSv1.2_2021"
            },
            "DefaultCacheBehavior": {
                "ViewerProtocolPolicy": "redirect-to-https",
                "Compress": False,
                "ForwardedValues": {
                    "QueryString": False,
                    "Cookies": {"Forward": "none"}
                }
            }
        }
    })

    # Assert Lambda function for deployment/cleanup
    template.has_resource_properties("AWS::Lambda::Function", {
        "Handler": "index.handler",
        "Runtime": "nodejs18.x"
    })

    # Assert Lambda custom resource
    template.has_resource_properties("AWS::CloudFormation::CustomResource", {
        "ServiceToken": Match.string_like_regexp("arn:aws:lambda:.*:.*:function:.*")
    })

    # Assert S3 bucket resource count
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert CloudFront distribution resource count
    template.resource_count_is("AWS::CloudFront::Distribution", 1)

    # Assert Lambda function resource count
    template.resource_count_is("AWS::Lambda::Function", 1)