output "id" {
  description = "The Amazon Connect instance ID, Lex (V1) bot name, and Lex (V1) bot region separated by colons (:)."
  value       = aws_connect_bot_association.this.id
}