resource "aws_lexv2models_bot_locale" "this" {
  bot_id                           = var.bot_id
  bot_version                      = var.bot_version
  locale_id                        = var.locale_id
  n_lu_intent_confidence_threshold = var.n_lu_intent_confidence_threshold

  region      = var.region
  description = var.description

  dynamic "voice_settings" {
    for_each = var.voice_settings != null ? [var.voice_settings] : []
    content {
      voice_id = voice_settings.value.voice_id
      engine   = voice_settings.value.engine
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}