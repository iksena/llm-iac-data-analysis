output "repository_name" {
  value = "${github_repository.repository.full_name}"
}

output "git_clone_url" {
  value = "${github_repository.repository.http_clone_url}"
}
