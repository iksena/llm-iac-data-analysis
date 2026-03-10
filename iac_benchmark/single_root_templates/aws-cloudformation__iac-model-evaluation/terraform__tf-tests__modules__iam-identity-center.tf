# ── main.tf ────────────────────────────────────
# - IAM Identity Center Dynamic Group Creation -
resource "aws_identitystore_group" "sso_groups" {
  for_each          = var.sso_groups == null ? {} : var.sso_groups
  identity_store_id = local.sso_instance_id
  display_name      = each.value.group_name
  description       = each.value.group_description
}


# - IAM Identity Center Dynamic User Creation -
resource "aws_identitystore_user" "sso_users" {
  for_each          = var.sso_users == null ? {} : var.sso_users
  identity_store_id = local.sso_instance_id

  # -- PROFILE DETAILS --
  # - Primary Information -
  // (Required) The name that is typically displayed when the user is referenced
  // The default is the provided given name and family name.
  # display_name = each.value.display_name
  display_name = join(" ", [each.value.given_name, each.value.family_name])

  //(Required, Forces new resource) A unique string used to identify the user. This value can consist of letters, accented characters, symbols, numbers, and punctuation. This value is specified at the time the user is created and stored as an attribute of the user object in the identity store. The limit is 128 characters
  user_name = each.value.user_name

  //(Required) Details about the user's full name. Detailed below
  name {
    // (Required) First name
    given_name = each.value.given_name
    // (Optional) Middle name
    // Default value is null.
    middle_name = lookup(each.value, "middle_name", null)
    // (Required) Last name
    family_name = each.value.family_name
    // (Optional) The name that is typically displayed when the name is shown for display.
    // Default value is the provided given name and family name.
    formatted = lookup(each.value, "name_formatted", join(" ", [each.value.given_name, each.value.family_name]))
    // (Optional) The honorific prefix of the user.
    // Default value is null.
    honorific_prefix = lookup(each.value, "honorific_prefix", null)
    // (Optional) The honorific suffix of the user
    // Default value is null.
    honorific_suffix = lookup(each.value, "honorific_suffix", null)
  }

  // (Optional) Details about the user's email. At most 1 email is allowed. Detailed below.
  // Required for this module to ensure users have an email on file for resetting password and receiving OTP.
  emails {
    // (Optional) The email address. This value must be unique across the identity store.
    // Required for this module as explained above.
    value = each.value.email
    //(Optional) When true, this is the primary email associated with the user.
    // Default value is true.
    primary = lookup(each.value, "is_primary_email", true)
    // (Optional) The type of email.
    // Default value is null.
    type = lookup(each.value, "email_type", null)
  }

  //(Optional) Details about the user's phone number. At most 1 phone number is allowed. Detailed below.
  phone_numbers {
    //(Optional) The user's phone number.
    // Default value is null.
    value = lookup(each.value, "phone_number", null)
    // (Optional) When true, this is the primary phone number associated with the user.
    // Default value is true.
    primary = lookup(each.value, "is_primary_phone_number", true)
    // (Optional) The type of phone number.
    // // Default value is null.
    type = lookup(each.value, "phone_number_type", null)
  }

  // (Optional) Details about the user's address. At most 1 address is allowed. Detailed below.
  addresses {
    // (Optional) The country that this address is in.
    // Default value is null.
    country = lookup(each.value, "country", null)
    // (Optional) The address locality. You can use this for City/Town/Village
    // Default value is null.
    locality = lookup(each.value, "locality", null)
    //(Optional) The name that is typically displayed when the address is shown for display.
    // Default value is the provided street address, locality, region, postal code, and country.
    formatted = lookup(each.value, "address_formatted", join(" ", [lookup(each.value, "street_address", ""), lookup(each.value, "locality", ""), lookup(each.value, "region", ""), lookup(each.value, "postal_code", ""), lookup(each.value, "country", "")]))
    // (Optional) The postal code of the address.
    // Default value is null.
    postal_code = lookup(each.value, "postal_code", null)
    // (Optional) When true, this is the primary address associated with the user.
    // Default value is null.
    primary = lookup(each.value, "is_primary_address", true)
    // (Optional) The region of the address. You can use this for State/Parish/Province.
    // Default value is true.
    region = lookup(each.value, "region", null)
    // (Optional) The street of the address.
    // Default value is null.
    street_address = lookup(each.value, "street_address", null)
    // (Optional) The type of address.
    // Default value is null.
    type = lookup(each.value, "address_type", null)
  }

  # -- Additional information --
  // (Optional) The user type.
  // Default value is null.
  user_type = lookup(each.value, "user_type", null)
  // (Optional) The user's title. Ex. Developer, Principal Architect, Account Manager, etc.
  // Default value is null.
  title = lookup(each.value, "title", null)
  // (Optional) The user's geographical region or location. Ex. US-East, EU-West, etc.
  // Default value is null.
  locale = lookup(each.value, "locale", null)
  // (Optional) An alternate name for the user.
  // Default value is null.
  nickname = lookup(each.value, "nickname", null)
  // (Optional) The preferred language of the user.
  // Default value is null.
  preferred_language = lookup(each.value, "preferred_language", null)
  // (Optional) An URL that may be associated with the user.
  // Default value is null.
  profile_url = lookup(each.value, "profile_url", null)
  // (Optional) The user's time zone.
  // Default value is null.
  # timezone = each.value.timezone
  timezone = lookup(each.value, "timezone", null)

  # ** IMPORTANT - NOT CURRENTLY SUPPORTED - Will add support when Terraform resource is updated. **
  # employee_number = lookup(each.value, "employee_number", null)
  # cost_center = lookup(each.value, "cost_center", null)
  # organization = lookup(each.value, "organization", null)
  # division = lookup(each.value, "division", null)
  # department = lookup(each.value, "department", null)
  # manager = lookup(each.value, "manager", null)

}


# - Identity Store Group Membership -
resource "aws_identitystore_group_membership" "sso_group_membership" {
  for_each          = local.users_and_their_groups
  identity_store_id = local.sso_instance_id

  group_id  = data.aws_identitystore_group.existing_sso_groups[each.key].group_id
  member_id = data.aws_identitystore_user.existing_sso_users[each.key].user_id
}


# - SSO Permission Set -
resource "aws_ssoadmin_permission_set" "pset" {
  for_each = var.permission_sets
  name     = each.key

  # lookup function retrieves the value of a single element from a map, when provided it's key.
  # if the given key does not exist, the default value (null) is returned instead

  instance_arn     = local.ssoadmin_instance_arn
  description      = lookup(each.value, "description", null)
  relay_state      = lookup(each.value, "relay_state", null)      // (Optional) URL used to redirect users within the application during the federation authentication process
  session_duration = lookup(each.value, "session_duration", null) // The length of time that the application user sessions are valid in the ISO-8601 standard
  tags             = lookup(each.value, "tags", {})
}


# - AWS Managed Policy Attachment -
resource "aws_ssoadmin_managed_policy_attachment" "pset_aws_managed_policy" {
  # iterate over the permission_sets map of maps, and set the result to be pset_name and pset_index
  # ONLY if the policy for each pset_index is valid.
  for_each = { for pset in local.pset_aws_managed_policy_maps : "${pset.pset_name}.${pset.policy_arn}" => pset }

  instance_arn       = local.ssoadmin_instance_arn
  managed_policy_arn = each.value.policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.pset[each.value.pset_name].arn

  depends_on = [aws_ssoadmin_account_assignment.account_assignment]
}


# - Customer Managed Policy Attachment -
resource "aws_ssoadmin_customer_managed_policy_attachment" "pset_customer_managed_policy" {
  for_each = { for pset in local.pset_customer_managed_policy_maps : "${pset.pset_name}.${pset.policy_name}" => pset }

  instance_arn       = local.ssoadmin_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.pset[each.value.pset_name].arn
  customer_managed_policy_reference {
    name = each.value.policy_name
    path = "/"
  }

}


#  ! NOT CURRENTLY SUPPORTED !
# - Inline Policy -
# resource "aws_ssoadmin_permission_set_inline_policy" "pset_inline_policy" {
#   for_each = { for pset_name, pset_index in var.permission_sets : pset_name => pset_index if can(pset_index.inline_policy) }

#   inline_policy      = each.value.inline_policy[0]
#   instance_arn       = local.ssoadmin_instance_arn
#   permission_set_arn = aws_ssoadmin_permission_set.pset[each.key].arn
# }

resource "aws_ssoadmin_account_assignment" "account_assignment" {
  for_each = local.principals_and_their_account_assignments // for_each arguement must be a map, or set of strings. Tuples won't work

  instance_arn       = local.ssoadmin_instance_arn
  permission_set_arn = data.aws_ssoadmin_permission_set.existing_permission_sets[each.key].arn

  principal_id   = each.value.principal_type == "GROUP" ? data.aws_identitystore_group.identity_store_group[each.value.principal_name].id : data.aws_identitystore_user.identity_store_user[each.value.principal_name].id
  principal_type = each.value.principal_type

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"
}


# ── variables.tf ────────────────────────────────────
# Groups
variable "sso_groups" {
  description = "Names of the groups you wish to create in IAM Identity Center"
  type        = map(any)
  default     = {}

  # validation {
  #   condition     = alltrue([for group in values(var.sso_groups) : length(group.group_name) >= 3 && length(group.group_name) <= 128])
  #   error_message = "The name of one of the defined IAM Identity Center Groups is too long. Group names can be a maxmium of 128 characters, as the names are used by other resources throughout this module. This can cause deployment failures for AWS resources with smaller character limits for naming. Please ensure all group names are 128 characters or less, and try again."
  # }
}

# Users
variable "sso_users" {
  description = "Names of the users you wish to create in IAM Identity Center"
  type        = map(any)
  default     = {}

  validation {
    condition     = alltrue([for user in values(var.sso_users) : length(user.user_name) >= 3 && length(user.user_name) <= 128])
    error_message = "The name of one of the defined IAM Identity Center usernames is too long. Usernames can be a maxmium of 128 characters, as the names are used by other resources throughout this module. This can cause deployment failures for AWS resources with smaller character limits for naming. Please ensure all group names are 128 characters or less, and try again."
  }
}

# Permission Sets
variable "permission_sets" {
  description = "Map of maps containing Permission Set names as keys. See permission_sets description in README for information about map values."
  type        = any
  default = {
    # key
    AdministratorAccess = {
      # values
      description      = "Provides full access to AWS services and resources.",
      session_duration = "PT2H",
      managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    }
  }
}

#  Account Assignments
variable "account_assignments" {
  description = "List of maps containing mapping between user/group, permission set and assigned accounts list. See account_assignments description in README for more information about map values."
  type        = map(any)

  default = {}
}


# ── outputs.tf ────────────────────────────────────
output "account_assignment_data" {
  value       = local.flatten_account_assignment_data
  description = "Tuple containing account assignment data"

}

output "principals_and_assignments" {
  value       = local.principals_and_their_account_assignments
  description = "Map containing account assignment data"

}

output "sso_groups_ids" {
  value       = { for k, v in aws_identitystore_group.sso_groups : k => v.group_id }
  description = "A map of SSO groups ids created by this module"
}


# ── providers.tf ────────────────────────────────────
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.35.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 0.55.0"
    }
  }
}


# ── locals.tf ────────────────────────────────────
# - Users and Groups -
locals {
  # Create a new local variable by flattening the complex type given in the variable "sso_users"
  flatten_user_data = flatten([
    for this_user in keys(var.sso_users) : [
      for group in var.sso_users[this_user].group_membership : {
        user_name  = var.sso_users[this_user].user_name
        group_name = group
      }
    ]
  ])

  users_and_their_groups = {
    for s in local.flatten_user_data : format("%s_%s", s.user_name, s.group_name) => s
  }

}


# - Permission Sets and Policies -
locals {
  # - Fetch SSO Instance ARN and SSO Instance ID -
  ssoadmin_instance_arn = tolist(data.aws_ssoadmin_instances.sso_instance.arns)[0]
  sso_instance_id       = tolist(data.aws_ssoadmin_instances.sso_instance.identity_store_ids)[0]

  # Iterate over the objects in var.permission sets, then evaluate the expression's 'pset_name'
  # and 'pset_index' with 'pset_name' and 'pset_index' only if the pset_index.managed_policies (AWS Managed Policy ARN)
  # produces a result without an error (i.e. if the ARN is valid). If any of the ARNs for any of the objects
  # in the map are invalid, the for loop will fail.

  # pset_name is the attribute name for each permission set map/object
  # pset_index is the corresponding index of the map of maps (which is the variable permission_sets)
  aws_managed_permission_sets      = { for pset_name, pset_index in var.permission_sets : pset_name => pset_index if can(pset_index.aws_managed_policies) }
  customer_managed_permission_sets = { for pset_name, pset_index in var.permission_sets : pset_name => pset_index if can(pset_index.customer_managed_policies) }

  #  ! NOT CURRENTLY SUPPORTED !
  # inline_policy_permission_sets = { for pset_name, pset_index in var.permission_sets : pset_name => pset_index if can(pset_index.inline_policy) }



  # When using the 'for' expression in Terraform:
  # [ and ] produces a tuple
  # { and } produces an object, and you must provide two result expressions separated by the => symbol
  # The 'flatten' function takes a list and replaces any elements that are lists with a flattened sequence of the list contents

  # create pset_name and managed policy maps list. flatten is needed because the result is a list of maps.name
  # This nested for loop will run only if each of the managed_policies are valid ARNs.

  # - AWS Managed Policies -
  pset_aws_managed_policy_maps = flatten([
    for pset_name, pset_index in local.aws_managed_permission_sets : [
      for policy in pset_index.aws_managed_policies : {
        pset_name  = pset_name
        policy_arn = policy
      } if pset_index.aws_managed_policies != null && can(pset_index.aws_managed_policies)
    ]
  ])

  # - Customer Managed Policies -
  pset_customer_managed_policy_maps = flatten([
    for pset_name, pset_index in local.customer_managed_permission_sets : [
      for policy in pset_index.customer_managed_policies : {
        pset_name   = pset_name
        policy_name = policy
        # path = path
      } if pset_index.customer_managed_policies != null && can(pset_index.customer_managed_policies)
    ]
  ])

  #  ! NOT CURRENTLY SUPPORTED !
  # - Inline Policy -
  #   pset_inline_policy_maps = flatten([
  #     for pset_name, pset_index in local.inline_policy_permission_sets : [
  #       for policy in pset_index.inline_policy : {
  #         pset_name  = pset_name
  #         inline_policy = policy
  #         # path = path
  #       } if pset_index.inline_policy != null && can(pset_index.inline_policy)
  #     ]
  #   ])

}


# - Account Assignments -
locals {
  # Create a new local variable by flattening the complex type given in the variable "account_assignments"
  # This will be a 'tuple'
  flatten_account_assignment_data = flatten([
    for this_assignment in keys(var.account_assignments) : [
      for account in var.account_assignments[this_assignment].account_ids : [
        for pset in var.account_assignments[this_assignment].permission_sets : {
          permission_set = pset
          principal_name = var.account_assignments[this_assignment].principal_name
          principal_type = var.account_assignments[this_assignment].principal_type
          account_id     = account
        }
      ]
    ]
  ])


  #  Convert the flatten_account_assignment_data tuple into a map.
  # Since we will be using this local in a for_each, it must either be a map or a set of strings
  principals_and_their_account_assignments = {
    for s in local.flatten_account_assignment_data : format("Type:%s__Principal:%s__Permission:%s__Account:%s", s.principal_type, s.principal_name, s.permission_set, s.account_id) => s
  }


  # iterates over account_assignents, sets that to be assignment.principal_name ONLY if the assignment.principal_type
  #is GROUP. Essentially stores all the possible 'assignments' (account assignments) that would be attached to a user group

  # same thing, for sso_users but for USERs not GROUPs

  # 'account_assignments_for_groups' is effectively a list of principal names where the account type is GROUP
  account_assignments_for_groups = [for assignment in var.account_assignments : assignment.principal_name if assignment.principal_type == "GROUP"]

  # 'account_assignments_for_users' is effectively a list of principal names where the account type is USER
  account_assignments_for_users = [for assignment in var.account_assignments : assignment.principal_name if assignment.principal_type == "USER"]
}


# ── data.tf ────────────────────────────────────
# Fetch existing SSO Instance
data "aws_ssoadmin_instances" "sso_instance" {}


# The local variable 'users_and_their_groups' is a map of values for relevant user information.
# It contians a list of all users with the name of their group_assignments appended to the end of the string.
# This map is then fed into the 'identitystore_group' and 'identitystore_user' data sources with the 'for_each'
# meta argument to fetch necessary information (group_id, user_id) for each user. These values are needed
# to assign the sso users to groups.
# Ex: nuzumaki_Admin = {
# group_name = "Admin"
# user_name = "nuzumaki"
#     }
#     nuzumaki_Dev = {
# group_name = "Dev"
# user_name = "nuzumaki"
#     }
#     suchihaQA = {
# group_name = "QA"
# user_name = "suchiha"
#     }

# - Fetch of SSO Groups to be used for group membership assignment -
data "aws_identitystore_group" "existing_sso_groups" {
  for_each          = local.users_and_their_groups
  identity_store_id = local.sso_instance_id
  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value.group_name
    }
  }
  // Prevents failure if data fetch is attempted before GROUPS are created
  depends_on = [aws_identitystore_group.sso_groups]
}


# - Fetch of SSO Users to be used for group membership assignment -
data "aws_identitystore_user" "existing_sso_users" {
  for_each          = local.users_and_their_groups
  identity_store_id = local.sso_instance_id

  alternate_identifier {
    # Filter users by user_name (nuzumaki, suchiha, dovis, etc.)
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = each.value.user_name
    }
  }
  // Prevents failure if data fetch is attempted before USERS are created
  depends_on = [aws_identitystore_user.sso_users]
}


# - Fetch of SSO Groups to be used for account assignments (for GROUPS) -
data "aws_identitystore_group" "identity_store_group" {
  for_each          = toset(local.account_assignments_for_groups)
  identity_store_id = local.sso_instance_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value
    }
  }
  // Prevents failure if data fetch is attempted before GROUPS are created
  depends_on = [aws_identitystore_group.sso_groups]
}


# - Fetch of SSO Groups to be used for account assignments (for USERS) -
data "aws_identitystore_user" "identity_store_user" {
  for_each          = toset(local.account_assignments_for_users)
  identity_store_id = local.sso_instance_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = each.value
    }
  }
  // Prevents failure if data fetch is attempted before USERS are created
  depends_on = [aws_identitystore_user.sso_users]
}


# The local variable 'principals_and_their_permission_sets' is a map of values for relevant user information.
# It contians a list of all users with the name of their group_assignments appended to the end of the string.
# This map is then fed into the 'aws_ssoadmin_permission_set' data source with the 'for_each'meta argument to
# fetch necessary information (principal_id , parget_id) for each principal (user/group). These values are needed
# to assign permissions for users/groups to AWS accounts via account assignments.
# Format is 'Type:<principal_type>__Principal:<principal_name>__Permission:<permission_set>__Account:<account_id>'

# Ex: Type:GROUP__Principal:Admin__Permission:AdministratorAccess__Account:111111111111 = {
# principal_name = "Admin"
# principal_type = "GROUP"
# permission_sets = "AdministratorAccess"
# account_ids = "111111111111"
#     }
#     Type:GROUP__Principal:Admin__Permission:AdministratorAccess__Account:222222222222 = {
#       # principal_name = "Admin"
#       # principal_type = "GROUP"
#       # permission_sets = "AdministratorAccess"
#       # account_ids = "222222222222"
#     }
#     Type:GROUP__Principal:Admin__Permission:ViewOnlyAccess__Account:111111111111 = {
# principal_name = "Admin"
# principal_type = "GROUP"
# permission_sets = "ViewOnlyAccess"
# account_ids = "111111111111"
#     }

data "aws_ssoadmin_permission_set" "existing_permission_sets" {
  for_each     = local.principals_and_their_account_assignments
  instance_arn = local.ssoadmin_instance_arn
  name         = each.value.permission_set
  // Prevents failure if data fetch is attempted before Permission Sets are created
  depends_on = [aws_ssoadmin_permission_set.pset]
}
