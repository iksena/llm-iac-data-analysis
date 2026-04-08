output "certificate_arn" {
  value = aws_acm_certificate.certificate.arn

  depends_on = [aws_acm_certificate_validation.certificate_validation]
}
