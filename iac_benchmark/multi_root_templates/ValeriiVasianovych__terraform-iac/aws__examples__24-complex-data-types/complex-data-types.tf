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

