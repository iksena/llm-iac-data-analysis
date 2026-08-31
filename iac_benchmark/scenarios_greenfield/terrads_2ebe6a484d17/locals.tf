locals {
  default_tags = merge(var.inherited_tags, {
    Submodule = "utkusarioglu-com"
  })
  dev_tags = merge(local.default_tags, {
    Branch = "dev"
  })
  main_tags = merge(local.default_tags, {
    Branch = "main"
  })
  domain_name = "utkusarioglu.com"
  # dev_cloudfront_ttl = 0
  dev_cloudfront_ttl = 31536000
}
