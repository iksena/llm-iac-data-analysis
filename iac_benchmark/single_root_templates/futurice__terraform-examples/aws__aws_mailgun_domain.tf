# ── main.tf ────────────────────────────────────
# Create a new Mailgun domain
resource "mailgun_domain" "this" {
  name          = "${var.mail_domain}"
  spam_action   = "${var.spam_action}"
  wildcard      = "${var.wildcard}"
  smtp_password = "${var.smtp_password}"
}

# DNS records for domain setup & verification are below
# See https://app.mailgun.com/app/domains/<your-domain>/verify for these instructions

resource "aws_route53_record" "sending" {
  count = "${length(mailgun_domain.this.sending_records)}"

  zone_id = "${data.aws_route53_zone.this.zone_id}"
  name    = "${lookup(mailgun_domain.this.sending_records[count.index], "name")}"
  type    = "${lookup(mailgun_domain.this.sending_records[count.index], "record_type")}"
  ttl     = 300

  records = [
    "${lookup(mailgun_domain.this.sending_records[count.index], "value")}",
  ]
}

resource "aws_route53_record" "receiving" {
  zone_id = "${data.aws_route53_zone.this.zone_id}"
  name    = "${var.mail_domain}"
  type    = "${lookup(mailgun_domain.this.receiving_records[0], "record_type")}"
  ttl     = 300

  records = [
    "${lookup(mailgun_domain.this.receiving_records[0], "priority")} ${lookup(mailgun_domain.this.receiving_records[0], "value")}",
    "${lookup(mailgun_domain.this.receiving_records[1], "priority")} ${lookup(mailgun_domain.this.receiving_records[1], "value")}",
  ]
}


# ── variables.tf ────────────────────────────────────
variable "mail_domain" {
  description = "Domain which you want to use for sending/receiving email (e.g. `\"example.com\"`)"
}

variable "smtp_password" {
  description = "Password that Mailgun will require for sending out SMPT mail via this domain"
}

variable "spam_action" {
  description = "See https://www.terraform.io/docs/providers/mailgun/r/domain.html#spam_action"
  default     = "disabled"
}

variable "wildcard" {
  description = "See https://www.terraform.io/docs/providers/mailgun/r/domain.html#wildcard"
  default     = false
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible); see https://aws.amazon.com/answers/account-management/aws-tagging-strategies/"
  type        = "map"
  default     = {}
}


# ── outputs.tf ────────────────────────────────────
output "mail_domain" {
  value       = "${var.mail_domain}"
  description = "Domain which you want to use for sending/receiving email (e.g. `\"example.com\"`)"
}

output "api_base_url" {
  value       = "https://api.mailgun.net/v3/${var.mail_domain}/"
  description = "Base URL of the Mailgun API for your domain"
}


# ── data.tf ────────────────────────────────────
data "aws_route53_zone" "this" {
  name = "${replace("${var.mail_domain}", "/.*\\b(\\w+\\.\\w+)\\.?$/", "$1")}" # e.g. "foo.example.com" => "example.com"
}
