output "arn" {
  description = "ARN of the bot."
  value       = data.aws_lex_bot.this.arn
}

output "checksum" {
  description = "Checksum of the bot used to identify a specific revision of the bot's $LATEST version."
  value       = data.aws_lex_bot.this.checksum
}

output "child_directed" {
  description = "If this Amazon Lex Bot is related to a website, program, or other application that is directed or targeted, in whole or in part, to children under age 13 and subject to COPPA."
  value       = data.aws_lex_bot.this.child_directed
}

output "created_date" {
  description = "Date that the bot was created."
  value       = data.aws_lex_bot.this.created_date
}

output "description" {
  description = "Description of the bot."
  value       = data.aws_lex_bot.this.description
}

output "detect_sentiment" {
  description = "When set to true user utterances are sent to Amazon Comprehend for sentiment analysis."
  value       = data.aws_lex_bot.this.detect_sentiment
}

output "enable_model_improvements" {
  description = "Set to true if natural language understanding improvements are enabled."
  value       = data.aws_lex_bot.this.enable_model_improvements
}

output "failure_reason" {
  description = "If the status is FAILED, the reason why the bot failed to build."
  value       = data.aws_lex_bot.this.failure_reason
}

output "idle_session_ttl_in_seconds" {
  description = "The maximum time in seconds that Amazon Lex retains the data gathered in a conversation."
  value       = data.aws_lex_bot.this.idle_session_ttl_in_seconds
}

output "last_updated_date" {
  description = "Date that the bot was updated."
  value       = data.aws_lex_bot.this.last_updated_date
}

output "locale" {
  description = "Target locale for the bot. Any intent used in the bot must be compatible with the locale of the bot."
  value       = data.aws_lex_bot.this.locale
}

output "name" {
  description = "Name of the bot, case sensitive."
  value       = data.aws_lex_bot.this.name
}

output "nlu_intent_confidence_threshold" {
  description = "The threshold where Amazon Lex will insert the AMAZON.FallbackIntent, AMAZON.KendraSearchIntent, or both when returning alternative intents in a PostContent or PostText response. AMAZON.FallbackIntent and AMAZON.KendraSearchIntent are only inserted if they are configured for the bot."
  value       = data.aws_lex_bot.this.nlu_intent_confidence_threshold
}

output "status" {
  description = "Status of the bot."
  value       = data.aws_lex_bot.this.status
}

output "version" {
  description = "Version of the bot. For a new bot, the version is always $LATEST."
  value       = data.aws_lex_bot.this.version
}

output "voice_id" {
  description = "Amazon Polly voice ID that the Amazon Lex Bot uses for voice interactions with the user."
  value       = data.aws_lex_bot.this.voice_id
}