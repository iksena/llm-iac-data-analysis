def test_template(template: Template):
    # S3 bucket with Origin Access Control
    template.resource_count_is("AWS::S3::Bucket", 1)
    template.has_resource_properties("AWS::S3::Bucket", {
        "AccessControl": "Private",
        "OriginAccessControls": Match.array_with({
            "Name": Match.any_value(),
            "Type": "origin-access-control",
            "Description": Match.any_value(),
            "AllowReadBasedOnOriginAccessControlOriginId": Match.any_value()
        })
    })

    # CloudFront distribution with custom cache policy
    template.resource_count_is("AWS::CloudFront::Distribution", 1)
    template.has_resource_properties("AWS::CloudFront::Distribution", {
        "DistributionConfig": {
            "DefaultCacheBehavior": {
                "CachePolicyId": Match.string_like_regexp(".*"),
                "ViewerProtocolPolicy": "redirect-to-https"
            },
            "CacheBehaviors": Match.array_with({
                "CachePolicyId": Match.string_like_regexp(".*"),
                "ViewerProtocolPolicy": "redirect-to-https"
            })
        }
    })

    # Lambda custom resource for bucket initialization
    template.resource_count_is("AWS::Lambda::Function", 1)
    template.has_resource_properties("AWS::Lambda::Function", {
        "Handler": "index.handler",
        "Runtime": "nodejs*"
    })

    # Custom resource that triggers Lambda
    template.resource_count_is("AWS::CloudFormation::CustomResource", 1)
    template.has_resource_properties("AWS::CloudFormation::CustomResource", {
        "ServiceToken": Match.string_like_regexp("arn:aws:lambda:.*")
    })

    # Output for CloudFront distribution URL
    template.has_output("CloudFrontDistributionUrl", {
        "Value": Match.string_like_regexp("https://.*\.cloudfront\.net")
    })