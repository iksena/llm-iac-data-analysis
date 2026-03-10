# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/examples/24-complex-data-types/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}

# ── variables.tf ────────────────────────────────────
variable "region" {
  description = "The AWS region to launch the resources."
  type        = string
  default     = "us-east-1"
}

# ── complex-data-types.tf ────────────────────────────────────
# All of complex data types in terraform are immutable.
# It means that you cannot change them. You can only create new values based on the existing ones.

# List
# 1. Contain dublicates
# 2. Only one type of data
# 3. Ordered
# 4. Can be accessed by index
# 5. List in terraform can be changed using: length(), concat(), slice(), join(), distinct(), reverse(), sort(), flatten()
variable "list_example" {
  type    = list(string)
  default = ["cat", "dog", "bird", "cat", "cat", "Cat"]
}

variable "list_of_lists_example" {
  type    = list(list(string))
  default = [["cat", "dog"], ["bird", "fish"]]
}

output "list_example" {
  value = var.list_example
}

##############################################

# Map
# 1. Key-value pairs
# 2. Can have different types of data
# 3. Unordered (it means that the order of the keys is not guaranteed)
# 4. Can be accessed by key. Example: var.map_example["year"]
# 5. Map in terraform can be changed using: keys(), values(), merge(), contains(), length(), containskey(), lookup(), zipmap(), setproduct()
variable "map_example" {
  type    = map(any)
  default = { "year" = 2010, "model" = "Ford" }
}

output "map_example" {
  value = var.map_example
}

output "map_example_year" {
  value = var.map_example["year"]
}

##############################################

# Set
# 1. Unique values
# 2. Only one type of data
# 3. Unordered
# 4. Cannot be accessed by index
# 5. Set in terraform can be changed using: length(), contains(), union(), intersection(), difference(), isdisjoint(), issubset(), issuperset(), tolist() etc.
variable "set_example" {
  type    = set(string)
  default = ["cat", "dog", "bird", "cat", "Cat"] # Cat and cat are different values
}

output "set_example" {
  value = var.set_example
}

##############################################

# Object
# 1. Key-value pairs
# 2. Can have different types of data
# 3. Unordered
# 4. Can be accessed by key. Example: var.object_example["name"]
# 5. Object in terraform can be changed using: keys(), values(), merge(), contains(), length(), containskey(), lookup(), zipmap(), setproduct()
variable "object_example" {
  type = object({
    name = string
    age  = number
  })
  default = {
    name = "John"
    age  = 30
  }
}

output "object_example" {
  value = var.object_example
}

##############################################

# Tuple
# 1. Ordered
# 2. Can have different types of data
# 3. Can be accessed by index
# 4. Tuple in terraform can be changed using: length(), concat(), slice(), join(), distinct(), reverse(), sort(), flatten()
# 5. Tuple is immutable
variable "tuple_example" {
  #type    = tuple([string, number, string, string])
  default = ["John", 30, "New York", "USA"]
}

output "tuple_example" {
  value = var.tuple_example
}



# ── func-list.tf ────────────────────────────────────
output "list_example_reversed" {
  value = reverse(var.list_example) # reverse the list
}

output "list_example_distinct" {
  value = distinct(var.list_example) # remove duplicates
}

output "list_example_joined" {
  value = join("-", var.list_example) # - separated list: cat-dog-bird-cat-cat
}

output "list_example_sliced" {
  value = slice(var.list_example, 1, 3) # slice the list from index 1 to 3 # two elements: dog, bird because 1 is't included and 2 and 3 are included
}

output "list_example_concatenated" {
  value = concat(var.list_example, ["fish", "elephant"]) # add two elements to the list
}

output "list_example_sorted" {
  value = sort(var.list_example) # sort the list
}

# combine some functions
output "list_example_combined" {
  value = sort(concat(distinct(var.list_example), ["fish", "elephant"])) # sort the list, remove duplicates and add two elements
}

output "list_of_lists_example_flattened" {
  value = flatten(var.list_of_lists_example) # flatten the list of lists
}

output "list_example_length" {
  value = length(var.list_example) # length of the list
}

output "list_example_toset" {
  value = toset(var.list_example) # convert the list to set
}