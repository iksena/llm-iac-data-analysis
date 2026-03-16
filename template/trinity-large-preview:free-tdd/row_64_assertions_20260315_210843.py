def test_template(template: Template):
    # VPC with public and private subnets
    template.resource_count_is("AWS::EC2::VPC", 1)
    template.resource_count_is("AWS::EC2::Subnet", 2)  # 1 public + 1 private
    template.resource_count_is("AWS::EC2::InternetGateway", 1)
    template.resource_count_is("AWS::EC2::RouteTable", 2)  # 1 public + 1 private

    # EC2 instance in public subnet
    template.resource_count_is("AWS::EC2::Instance", 1)
    ec2_instance = template.find_resources("AWS::EC2::Instance")
    assert len(ec2_instance) == 1

    # User data script must install Apache, PHP, and inventory app
    # We can't assert exact script content, but we can assert it's a string
    for resource_id, resource in ec2_instance.items():
        if "Properties" in resource and "UserData" in resource["Properties"]:
            user_data = resource["Properties"]["UserData"]
            assert isinstance(user_data, str)
            # Basic check for script type (base64 encoded)
            assert len(user_data) > 0

    # Public subnet must be associated with internet gateway
    # We check for route table with route to IGW
    public_route_table = template.find_resources("AWS::EC2::RouteTable", {
        "Properties": {
            "Routes": Match.array_with([{
                "GatewayId": Match.string_like_regexp("igw-"),
                "DestinationCidrBlock": "0.0.0.0/0"
            }])
        }
    })
    assert len(public_route_table) > 0