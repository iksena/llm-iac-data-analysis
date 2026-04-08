resource "aws_codecommit_trigger" "this" {
  repository_name = var.repository_name

  dynamic "trigger" {
    for_each = var.trigger
    content {
      name            = trigger.value.name
      destination_arn = trigger.value.destination_arn
      events          = trigger.value.events
      custom_data     = trigger.value.custom_data
      branches        = trigger.value.branches
    }
  }
}