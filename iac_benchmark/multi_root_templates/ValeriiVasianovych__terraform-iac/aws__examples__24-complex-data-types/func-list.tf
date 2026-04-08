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