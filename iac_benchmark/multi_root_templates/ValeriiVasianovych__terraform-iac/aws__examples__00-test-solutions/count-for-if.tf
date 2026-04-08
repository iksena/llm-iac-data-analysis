variable "aws_users" {
  description = "This is array with names of new users"
  type        = list(string)
  default     = ["ola", "wika", "nastya", "alisa"]
}

# terraform plan -target=aws_ian_user.users
resource "aws_iam_user" "users" {
  count = length(var.aws_users)               # number of users from list
  name  = element(var.aws_users, count.index) # names of users
  tags = {
    Names : "Name of user: ${element(var.aws_users, count.index)}"
    Number : "Number of user from Terraform array: ${count.index + 1}"
  }
}

# attach addministrator policy to users
data "aws_iam_policy" "admin_policy" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user_policy_attachment" "admin_policy" {
  count      = length(var.aws_users)
  user       = element(aws_iam_user.users[*].name, count.index)
  policy_arn = data.aws_iam_policy.admin_policy.arn
}

output "return_users" {
  value = aws_iam_user.users
}

output "iam_users_list" {
  value = [
    for i in aws_iam_user.users :
    "Username: ${i.name} has ARN: ${i.arn} and number in array ${index(aws_iam_user.users[*].name, i.name) + 1}"
  ]
}

output "iam_users_map" {
  value = {
    for i in aws_iam_user.users :
    i.unique_id => "Name of user: ${i.id}"
  }
}

output "show_specific_users" {
  value = [
    for i in aws_iam_user.users :
    i.name if length(i.name) == 4
  ]
}

##############################################################

variable "numbers" {
  description = "This is array with names of new users"
  type        = list(number)
  default     = [1, 2, 3, 4, 5]
}

output "return_numbers" {
  value = length(var.numbers)
}