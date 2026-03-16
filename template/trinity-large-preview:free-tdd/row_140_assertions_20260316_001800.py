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

    # Assert CloudWatch Log Group exists with retention of 3 days
    template.has_resource_properties(
        "AWS::Logs::LogGroup",
        {
            "RetentionInDays": 3
        }
    )

    # Assert there is exactly one Step Functions state machine
    template.resource_count_is("AWS::StepFunctions::StateMachine", 1)

    # Assert there is exactly one Lambda function
    template.resource_count_is("AWS::Lambda::Function", 1)

    # Assert there is exactly one CloudWatch Log Group
    template.resource_count_is("AWS::Logs::LogGroup", 1)