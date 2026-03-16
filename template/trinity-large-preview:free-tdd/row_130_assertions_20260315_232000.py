<cdk_assertions>
def test_template(template: Template):
    # Assert exactly one IAM account password policy resource exists
    template.resource_count_is("AWS::IAM::AccountPasswordPolicy", 1)

    # Assert the Lambda function exists (for dynamic policy application)
    template.resource_count_is("AWS::Lambda::Function", 1)

    # Assert the Lambda function has the expected IAM execution role
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": [{
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": {"Service": "lambda.amazonaws.com"}
            }]
        }
    })

    # Assert the Lambda function has permissions to manage IAM policies
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": [
                    "iam:UpdateAccountPasswordPolicy",
                    "iam:DeleteAccountPasswordPolicy"
                ],
                "Effect": "Allow",
                "Resource": "*"
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogGroup",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:CreateLogStream",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": [{
                "Action": "logs:PutLogEvents",
                "Effect": "Allow",
                "Resource": Match.string_like_regexp("arn:aws:logs:*:*:.*")
            }]
        }
    })

    # Assert the Lambda function has permissions to write logs
    template.has_resource_properties("AWS::IAM::