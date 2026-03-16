def test_template(template: Template):
    # Assert Redis ElastiCache cluster exists
    template.resource_count_is("AWS::ElastiCache::CacheCluster", 1)

    # Assert EC2 instance exists
    template.resource_count_is("AWS::EC2::Instance", 1)

    # Assert SSM IAM role exists
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert VPC exists
    template.resource_count_is("AWS::EC2::VPC", 1)

    # Assert two subnets exist
    template.resource_count_is("AWS::EC2::Subnet", 2)

    # Assert security group exists
    template.resource_count_is("AWS::EC2::SecurityGroup", 1)

    # Assert SSM document exists
    template.resource_count_is("AWS::SSM::Document", 1)

    # Assert SSM parameter exists
    template.resource_count_is("AWS::SSM::Parameter", 1)

    # Assert SSM association exists
    template.resource_count_is("AWS::SSM::Association", 1)

    # Assert SSM managed instance policy exists
    template.resource_count_is("AWS::IAM::ManagedPolicy", 1)