# ── main.tf ────────────────────────────────────
terraform {
  required_providers {
    boundary = {
      source  = "hashicorp/boundary"
      version = "0.1.0"
    }
  }
}

provider "boundary" {
  addr             = var.url
  recovery_kms_hcl = <<EOT
kms "azurekeyvault" {
    purpose = "recovery"
	tenant_id     = "${var.tenant_id}"
    vault_name = "${var.vault_name}"
    key_name = "recovery"
}
EOT
}

# ── auth.tf ────────────────────────────────────
resource "boundary_auth_method" "password" {
  name        = "corp_password_auth_method"
  description = "Password auth method for Corp org"
  type        = "password"
  scope_id    = boundary_scope.org.id
}

# ── hosts.tf ────────────────────────────────────
resource "boundary_host_catalog" "backend_servers" {
  name        = "backend_servers"
  description = "Web servers for backend team"
  type        = "static"
  scope_id    = boundary_scope.core_infra.id
}

resource "boundary_host" "backend_servers" {
  for_each        = var.target_ips
  type            = "static"
  name            = "backend_server_${each.value}"
  description     = "Backend server #${each.value}"
  address         = each.key
  host_catalog_id = boundary_host_catalog.backend_servers.id
}

resource "boundary_host_set" "backend_servers" {
  type            = "static"
  name            = "backend_servers"
  description     = "Host set for backend servers"
  host_catalog_id = boundary_host_catalog.backend_servers.id
  host_ids        = [for host in boundary_host.backend_servers : host.id]
}


# ── principles.tf ────────────────────────────────────
resource "boundary_user" "backend" {
  for_each    = var.backend_team
  name        = each.key
  description = "Backend user: ${each.key}"
  account_ids = [boundary_account.backend_user_acct[each.value].id]
  scope_id    = boundary_scope.org.id
}

resource "boundary_user" "frontend" {
  for_each    = var.frontend_team
  name        = each.key
  description = "Frontend user: ${each.key}"
  account_ids = [boundary_account.frontend_user_acct[each.value].id]
  scope_id    = boundary_scope.org.id
}

resource "boundary_user" "leadership" {
  for_each    = var.leadership_team
  name        = each.key
  description = "WARNING: Managers should be read-only"
  account_ids = [boundary_account.leadership_user_acct[each.value].id]
  scope_id    = boundary_scope.org.id
}

resource "boundary_account" "backend_user_acct" {
  for_each       = var.backend_team
  name           = each.key
  description    = "User account for ${each.key}"
  type           = "password"
  login_name     = lower(each.key)
  password       = "foofoofoo"
  auth_method_id = boundary_auth_method.password.id
}

resource "boundary_account" "frontend_user_acct" {
  for_each       = var.frontend_team
  name           = each.key
  description    = "User account for ${each.key}"
  type           = "password"
  login_name     = lower(each.key)
  password       = "foofoofoo"
  auth_method_id = boundary_auth_method.password.id
}

resource "boundary_account" "leadership_user_acct" {
  for_each       = var.leadership_team
  name           = each.key
  description    = "User account for ${each.key}"
  type           = "password"
  login_name     = lower(each.key)
  password       = "foofoofoo"
  auth_method_id = boundary_auth_method.password.id
}

// organiation level group for the leadership team
resource "boundary_group" "leadership" {
  name        = "leadership_team"
  description = "Organization group for leadership team"
  member_ids  = [for user in boundary_user.leadership : user.id]
  scope_id    = boundary_scope.org.id
}

// project level group for backend and frontend management of core infra
resource "boundary_group" "backend_core_infra" {
  name        = "backend"
  description = "Backend team group"
  member_ids  = [for user in boundary_user.backend : user.id]
  scope_id    = boundary_scope.core_infra.id
}

resource "boundary_group" "frontend_core_infra" {
  name        = "frontend"
  description = "Frontend team group"
  member_ids  = [for user in boundary_user.frontend : user.id]
  scope_id    = boundary_scope.core_infra.id
}


# ── roles.tf ────────────────────────────────────
# Allows anonymous (un-authenticated) users to list and authenticate against any
# auth method, list the global scope, and read and change password on their account ID
# at the global scope
resource "boundary_role" "global_anon_listing" {
  scope_id = boundary_scope.global.id
  grant_strings = [
    "id=*;type=auth-method;actions=list,authenticate",
    "type=scope;actions=list",
    "id={{account.id}};actions=read,change-password"
  ]
  principal_ids = ["u_anon"]
}

# Allows anonymous (un-authenticated) users to list and authenticate against any
# auth method, list the global scope, and read and change password on their account ID
# at the org level scope
resource "boundary_role" "org_anon_listing" {
  scope_id = boundary_scope.org.id
  grant_strings = [
    "id=*;type=auth-method;actions=list,authenticate",
    "type=scope;actions=list",
    "id={{account.id}};actions=read,change-password"
  ]
  principal_ids = ["u_anon"]
}

# Creates a role in the global scope that's granting administrative access to 
# resources in the org scope for all backend users
resource "boundary_role" "org_admin" {
  scope_id       = boundary_scope.global.id
  grant_scope_id = boundary_scope.org.id
  grant_strings = [
    "id=*;type=*;actions=*"
  ]
  principal_ids = concat(
    [for user in boundary_user.backend : user.id],
    [for user in boundary_user.frontend : user.id],
  )
}

# Adds a read-only role in the global scope granting read-only access
# to all resources within the org scope and adds principals from the 
# leadership team to the role
resource "boundary_role" "org_readonly" {
  name        = "readonly"
  description = "Read-only role"
  principal_ids = [
    boundary_group.leadership.id
  ]
  grant_strings = [
    "id=*;type=*;actions=read"
  ]
  scope_id       = boundary_scope.global.id
  grant_scope_id = boundary_scope.org.id
}

# Adds an org-level role granting administrative permissions within the core_infra project
resource "boundary_role" "project_admin" {
  name           = "core_infra_admin"
  description    = "Administrator role for core infra"
  scope_id       = boundary_scope.org.id
  grant_scope_id = boundary_scope.core_infra.id
  grant_strings = [
    "id=*;type=*;actions=*"
  ]
  principal_ids = concat(
    [for user in boundary_user.backend : user.id],
    [for user in boundary_user.frontend : user.id],
  )
}


# ── scopes.tf ────────────────────────────────────
resource "boundary_scope" "global" {
  global_scope = true
  name         = "global"
  scope_id     = "global"
}

resource "boundary_scope" "org" {
  scope_id    = boundary_scope.global.id
  name        = "organization"
  description = "Organization scope"
}

// create a project for core infrastructure
resource "boundary_scope" "core_infra" {
  name                     = "core_infra"
  description              = "Backend infrastrcture project"
  scope_id                 = boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}


# ── targets.tf ────────────────────────────────────
resource "boundary_target" "backend_servers_ssh" {
  type                     = "tcp"
  name                     = "backend_servers_ssh"
  description              = "Backend SSH target"
  scope_id                 = boundary_scope.core_infra.id
  session_connection_limit = -1
  default_port             = 22
  host_set_ids = [
    boundary_host_set.backend_servers.id
  ]
}

resource "boundary_target" "backend_servers_website" {
  type                     = "tcp"
  name                     = "backend_servers_website"
  description              = "Backend website target"
  scope_id                 = boundary_scope.core_infra.id
  session_connection_limit = -1
  default_port             = 8000
  host_set_ids = [
    boundary_host_set.backend_servers.id
  ]
}


# ── vars.tf ────────────────────────────────────
variable "url" {
  default = "http://127.0.0.1:9200"
}

variable "backend_team" {
  type = set(string)
  default = [
    "jim",
    "mike",
    "todd",
  ]
}

variable "frontend_team" {
  type = set(string)
  default = [
    "randy",
    "susmitha",
  ]
}

variable "leadership_team" {
  type = set(string)
  default = [
    "jeff",
    "pete",
    "jonathan",
    "malnick"
  ]
}

variable "target_ips" {
  type    = set(string)
  default = []
}

variable "tenant_id" {}

variable "vault_name" {}
