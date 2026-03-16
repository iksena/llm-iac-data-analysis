def test_template(template: Template):
    template.resource_count_is("AWS::EC2::VPC", 1)
    template.resource_count_is("AWS::EC2::SecurityGroup", 1)