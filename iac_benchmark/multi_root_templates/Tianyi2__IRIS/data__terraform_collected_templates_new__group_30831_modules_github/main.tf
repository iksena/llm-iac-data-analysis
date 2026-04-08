# create repository from config file
resource "github_repository" "repository" {
  name        = "${var.repository_name}"
  description = "${var.description}"
  visibility = "${var.visibility}"
  auto_init = true

}

# create additional branches if present
resource "github_branch" "branches" {
    for_each   = toset(var.branches)
    repository = "${github_repository.repository.name}"
    branch     =  "${each.key}"
}