output "id" {
  description = "ID of the MAC Security (MACSec) secret key resource."
  value       = aws_dx_macsec_key_association.this.id
}

output "start_on" {
  description = "The date in UTC format that the MAC Security (MACsec) secret key takes effect."
  value       = aws_dx_macsec_key_association.this.start_on
}

output "state" {
  description = "The state of the MAC Security (MACsec) secret key. The possible values are: associating, associated, disassociating, disassociated."
  value       = aws_dx_macsec_key_association.this.state
}