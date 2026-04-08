terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "chaotic-aur"

    workspaces {
      name = "github-management"
    }
  }
}
