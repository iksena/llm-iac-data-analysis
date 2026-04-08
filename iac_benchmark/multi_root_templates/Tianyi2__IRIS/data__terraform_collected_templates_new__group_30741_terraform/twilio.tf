
data "twilio_phone_number" "phone_number" {
  account_sid = var.twilio_account_sid
  sid         = var.twilio_phone_id
}

resource "null_resource" "twilio_trunk" {
  triggers = {
    friendly_name = var.twilio_trunk_friendly_name
  }

  provisioner "local-exec" {
    command = <<-EOT
      twilio api trunking v1 trunks create \
        --friendly-name "${var.twilio_trunk_friendly_name}" \
        --domain-name "${var.twilio_trunk_domain}"
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      TRUNK_SID=$(twilio api trunking v1 trunks list -o json | jq -r '.[] | select(.friendlyName=="${self.triggers.friendly_name}").sid')
      twilio api trunking v1 trunks remove --sid $TRUNK_SID
    EOT
  }
}

locals {
  get_trunk_sid_command = "twilio api trunking v1 trunks list -o json | jq -r '.[] | select(.friendlyName==\"${var.twilio_trunk_friendly_name}\").sid'"
}

resource "null_resource" "twilio_origination_url" {
  provisioner "local-exec" {
    command = <<-EOT
      TRUNK_SID=$(${local.get_trunk_sid_command})

      twilio api trunking v1 trunks origination-urls create \
        --trunk-sid $TRUNK_SID \
        --friendly-name "LiveKit SIP URI" \
        --sip-url "${var.livekit_sip_url}" \
        --weight 1 \
        --priority 1 \
        --enabled
    EOT
  }
  depends_on = [null_resource.twilio_trunk]
}

resource "null_resource" "twilio_phone_number_mapping" {
  provisioner "local-exec" {
    command = <<-EOT
      TRUNK_SID=$(${local.get_trunk_sid_command})

      twilio api trunking v1 trunks phone-numbers create \
        --trunk-sid $TRUNK_SID \
        --phone-number-sid ${var.twilio_phone_id}
    EOT
  }
  depends_on = [null_resource.twilio_trunk]
}

# resource "random_password" "sip_password" {
#   length  = 20
#   special = true
#   numeric = true
# }

# resource "null_resource" "twilio_sip_credentials" {
#   triggers = {
#     friendly_name       = "livekit-sip-creds"
#     username            = var.livekit_sip_username
#     trunk_friendly_name = var.twilio_trunk_friendly_name
#   }

#   provisioner "local-exec" {
#     command = <<-EOT
#       set -e
#       # Create SIP credentials list
#       twilio api core sip credential-lists create \
#         --friendly-name "${self.triggers.friendly_name}"

#       # Get the credential list SID
#       CRED_LIST_SID=$(twilio api core sip credential-lists list -o json | \
#         jq -r '.[] | select(.friendlyName=="${self.triggers.friendly_name}").sid')

#       # Create credential
#       twilio api core sip credential-lists credentials create \
#         --credential-list-sid $CRED_LIST_SID \
#         --username "${self.triggers.username}" \
#         --password "${random_password.sip_password.result}"

#       # Get trunk SID and associate credentials
#       TRUNK_SID=$(twilio api trunking v1 trunks list -o json | \
#         jq -r '.[] | select(.friendlyName=="${self.triggers.trunk_friendly_name}").sid')

#       twilio api trunking v1 trunks credentials-lists create \
#         --trunk-sid $TRUNK_SID \
#         --credential-list-sid $CRED_LIST_SID
#     EOT
#   }



#   provisioner "local-exec" {
#     when    = destroy
#     command = <<-EOT
#       set -e

#       # Get the credential list SID
#       CRED_LIST_SID=$(twilio api core sip credential-lists list -o json | \
#         jq -r '.[] | select(.friendlyName=="${self.triggers.friendly_name}").sid')

#       # Get trunk SID
#       TRUNK_SID=$(twilio api trunking v1 trunks list -o json | \
#         jq -r '.[] | select(.friendlyName=="${self.triggers.trunk_friendly_name}").sid')

#       # Remove credential list from trunk
#       twilio api trunking v1 trunks credentials-lists delete \
#         --trunk-sid $TRUNK_SID \
#         --sid $CRED_LIST_SID

#       # Delete the credential list (this will also delete all credentials in it)
#       twilio api core sip credential-lists delete --sid $CRED_LIST_SID
#     EOT
#   }

#   depends_on = [null_resource.twilio_trunk]
# }
