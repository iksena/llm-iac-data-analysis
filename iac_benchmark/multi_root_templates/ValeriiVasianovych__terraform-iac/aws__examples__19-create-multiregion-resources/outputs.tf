output "aws_caller_identity" {
    value = data.aws_caller_identity.current.id
}

output "show_created_vpc" {
    value = [
        aws_vpc.vpc-1.id,
        aws_vpc.vpc-2.id,
        aws_vpc.vpc-3.id
    ]
}