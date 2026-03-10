# ── main.tf ────────────────────────────────────
output "template" {
  value = templatefile("${path.module}/test.tmpl",
  {
    "mystring" = local.mystring
    "mylist"  = local.mylist
    "mymap" = local.mymap
    "myset" = local.myset
  })
}

# ── locals.tf ────────────────────────────────────
# Let's create some local values of different object types
locals {
  mystring = "taco"
  mylist = ["chicken","beef","fish"]
  myset = toset(local.mylist)
  mymap = {
      meat = "chicken"
      cheese = "jack"
      shell = "soft"
  }
}