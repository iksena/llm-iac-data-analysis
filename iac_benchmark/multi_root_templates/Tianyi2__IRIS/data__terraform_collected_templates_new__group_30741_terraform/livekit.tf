# Create LiveKit inbound trunk configuration
resource "local_file" "inbound_trunk_config" {
  filename = "${path.module}/inbound-trunk.json"
  content  = jsonencode({
    trunk = {
      name          = "Twilio inbound trunk"
      numbers       = [data.twilio_phone_number.phone_number.phone_number]
    }
  })
}

# Create LiveKit dispatch rule configuration template
resource "local_file" "dispatch_rule_template" {
  filename = "${path.module}/dispatch-rule.json.template"
  content  = jsonencode({
    name      = "Default dispatch rule"
    trunk_ids = ["{{TRUNK_ID}}"]
    rule = {
      dispatchRuleIndividual = {
        roomPrefix = "call"
      }
    }
  })
}

# First create the resources
resource "null_resource" "livekit_create" {
  triggers = {
    trunk_config_hash     = sha256(local_file.inbound_trunk_config.content)
    dispatch_rule_hash    = sha256(local_file.dispatch_rule_template.content)
  }

  provisioner "local-exec" {
    command = <<-EOT
      export LIVEKIT_URL=${var.livekit_url}
      export LIVEKIT_API_KEY=${var.livekit_api_key}
      export LIVEKIT_API_SECRET=${var.livekit_api_secret}

      # Create the trunk
      TRUNK_ID=$(lk sip inbound create ${local_file.inbound_trunk_config.filename} | grep -o 'SIPTrunkID: .*' | cut -d' ' -f2)
      if [ -z "$TRUNK_ID" ]; then
        echo "Failed to capture trunk ID" >&2
        exit 1
      fi
      echo "$TRUNK_ID" > .trunk_id

      # Create the dispatch rule
      sed "s/{{TRUNK_ID}}/$TRUNK_ID/" ${local_file.dispatch_rule_template.filename} > dispatch-rule.json
      DISPATCH_ID=$(lk sip dispatch create dispatch-rule.json | grep -o 'SIPDispatchRuleID: .*' | cut -d' ' -f2)
      if [ -z "$DISPATCH_ID" ]; then
        echo "Failed to capture dispatch ID" >&2
        exit 1
      fi
      echo "$DISPATCH_ID" > .dispatch_id

      rm -f dispatch-rule.json
    EOT
  }
}

# Then read the IDs into state
data "local_file" "trunk_id" {
  depends_on = [null_resource.livekit_create]
  filename   = ".trunk_id"
}

data "local_file" "dispatch_id" {
  depends_on = [null_resource.livekit_create]
  filename   = ".dispatch_id"
}

# Finally manage the lifecycle with the IDs in state
resource "null_resource" "livekit_setup" {
  depends_on = [null_resource.twilio_trunk, data.local_file.trunk_id, data.local_file.dispatch_id]

  triggers = {
    trunk_config_hash     = sha256(local_file.inbound_trunk_config.content)
    dispatch_rule_hash    = sha256(local_file.dispatch_rule_template.content)
    phone_number         = data.twilio_phone_number.phone_number.phone_number
    trunk_id            = data.local_file.trunk_id.content
    dispatch_id         = data.local_file.dispatch_id.content
    livekit_url         = var.livekit_url
    livekit_api_key     = var.livekit_api_key
    livekit_api_secret  = var.livekit_api_secret
  }

  lifecycle {
    precondition {
      condition = (
        data.local_file.trunk_id.content != null &&
        data.local_file.trunk_id.content != "" &&
        data.local_file.dispatch_id.content != null &&
        data.local_file.dispatch_id.content != ""
      )
      error_message = "LiveKit trunk_id and dispatch_id must not be null or empty"
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      set -e  # Exit on any error

      # Export credentials without echoing them
      export LIVEKIT_URL=${self.triggers.livekit_url}
      export LIVEKIT_API_KEY=${self.triggers.livekit_api_key}
      export LIVEKIT_API_SECRET=${self.triggers.livekit_api_secret}

      exec 1>livekit_destroy.log 2>&1  # Redirect all output to file

      echo "=== Starting LiveKit resource cleanup ==="

      echo "Current LiveKit resources before deletion (trunk ID: ${self.triggers.trunk_id}):"
      lk sip inbound list
      lk sip dispatch list


      echo "Deleting trunk ${self.triggers.trunk_id}..."

      if ! lk sip inbound delete `cat .trunk_id`; then
        echo "Failed to delete trunk"
        exit 1
      fi
      echo "Trunk deleted successfully"

      if ! lk sip dispatch delete `cat .dispatch_id`; then
        echo "Failed to delete dispatch rule"
        exit 1
      fi

      echo "Verifying deletion..."
      echo "Remaining trunks:"
      lk sip inbound list
      echo "Remaining dispatch rules:"
      lk sip dispatch list

      rm -f .trunk_id .dispatch_id
      echo "=== Cleanup completed ==="
    EOT
  }
}
