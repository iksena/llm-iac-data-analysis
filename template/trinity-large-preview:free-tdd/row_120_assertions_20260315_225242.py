def test_template(template: Template):
    # Assert SQS queue exists
    template.resource_count_is("AWS::SQS::Queue", 1)

    # Assert AWS Batch resources exist
    template.resource_count_is("AWS::Batch::ComputeEnvironment", 1)
    template.resource_count_is("AWS::Batch::JobQueue", 1)
    template.resource_count_is("AWS::Batch::JobDefinition", 1)

    # Assert EventBridge Pipe exists
    template.resource_count_is("AWS::Events::Pipe", 1)

    # Assert IAM roles exist
    template.resource_count_is("AWS::IAM::Role", 3)  # Batch, Pipes, ECS execution

    # Assert VPC resources exist
    template.resource_count_is("AWS::EC2::VPC", 1)
    template.resource_count_is("AWS::EC2::Subnet", 2)  # Assuming private subnets
    template.resource_count_is("AWS::EC2::SecurityGroup", 1)