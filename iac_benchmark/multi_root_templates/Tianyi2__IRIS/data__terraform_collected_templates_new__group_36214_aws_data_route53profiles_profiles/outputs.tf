output "profiles" {
  description = "List of Profiles"
  value = [
    for profile in data.aws_route53profiles_profiles.this.profiles : {
      arn          = profile.arn
      id           = profile.id
      name         = profile.name
      share_status = profile.share_status
    }
  ]
}