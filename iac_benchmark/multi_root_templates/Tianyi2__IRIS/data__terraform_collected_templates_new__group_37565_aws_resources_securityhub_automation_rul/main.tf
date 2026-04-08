resource "aws_securityhub_automation_rule" "this" {
  region      = var.region
  description = var.description
  rule_name   = var.rule_name
  rule_order  = var.rule_order
  is_terminal = var.is_terminal
  rule_status = var.rule_status

  actions {
    type = var.actions_type

    dynamic "finding_fields_update" {
      for_each = var.finding_fields_update != null ? [var.finding_fields_update] : []
      content {
        confidence          = finding_fields_update.value.confidence
        criticality         = finding_fields_update.value.criticality
        types               = finding_fields_update.value.types
        user_defined_fields = finding_fields_update.value.user_defined_fields
        verification_state  = finding_fields_update.value.verification_state

        dynamic "note" {
          for_each = finding_fields_update.value.note != null ? [finding_fields_update.value.note] : []
          content {
            text       = note.value.text
            updated_by = note.value.updated_by
          }
        }

        dynamic "related_findings" {
          for_each = finding_fields_update.value.related_findings != null ? finding_fields_update.value.related_findings : []
          content {
            id          = related_findings.value.id
            product_arn = related_findings.value.product_arn
          }
        }

        dynamic "severity" {
          for_each = finding_fields_update.value.severity != null ? [finding_fields_update.value.severity] : []
          content {
            label   = severity.value.label
            product = severity.value.product
          }
        }

        dynamic "workflow" {
          for_each = finding_fields_update.value.workflow != null ? [finding_fields_update.value.workflow] : []
          content {
            status = workflow.value.status
          }
        }
      }
    }
  }

  criteria {
    dynamic "aws_account_id" {
      for_each = var.criteria_aws_account_id != null ? var.criteria_aws_account_id : []
      content {
        comparison = aws_account_id.value.comparison
        value      = aws_account_id.value.value
      }
    }

    dynamic "aws_account_name" {
      for_each = var.criteria_aws_account_name != null ? var.criteria_aws_account_name : []
      content {
        comparison = aws_account_name.value.comparison
        value      = aws_account_name.value.value
      }
    }

    dynamic "company_name" {
      for_each = var.criteria_company_name != null ? var.criteria_company_name : []
      content {
        comparison = company_name.value.comparison
        value      = company_name.value.value
      }
    }

    dynamic "compliance_associated_standards_id" {
      for_each = var.criteria_compliance_associated_standards_id != null ? var.criteria_compliance_associated_standards_id : []
      content {
        comparison = compliance_associated_standards_id.value.comparison
        value      = compliance_associated_standards_id.value.value
      }
    }

    dynamic "compliance_security_control_id" {
      for_each = var.criteria_compliance_security_control_id != null ? var.criteria_compliance_security_control_id : []
      content {
        comparison = compliance_security_control_id.value.comparison
        value      = compliance_security_control_id.value.value
      }
    }

    dynamic "compliance_status" {
      for_each = var.criteria_compliance_status != null ? var.criteria_compliance_status : []
      content {
        comparison = compliance_status.value.comparison
        value      = compliance_status.value.value
      }
    }

    dynamic "confidence" {
      for_each = var.criteria_confidence != null ? var.criteria_confidence : []
      content {
        eq  = confidence.value.eq
        gte = confidence.value.gte
        lte = confidence.value.lte
      }
    }

    dynamic "created_at" {
      for_each = var.criteria_created_at != null ? var.criteria_created_at : []
      content {
        start = created_at.value.start
        end   = created_at.value.end

        dynamic "date_range" {
          for_each = created_at.value.date_range != null ? [created_at.value.date_range] : []
          content {
            unit  = date_range.value.unit
            value = date_range.value.value
          }
        }
      }
    }

    dynamic "criticality" {
      for_each = var.criteria_criticality != null ? var.criteria_criticality : []
      content {
        eq  = criticality.value.eq
        gte = criticality.value.gte
        lte = criticality.value.lte
      }
    }

    dynamic "description" {
      for_each = var.criteria_description != null ? var.criteria_description : []
      content {
        comparison = description.value.comparison
        value      = description.value.value
      }
    }

    dynamic "first_observed_at" {
      for_each = var.criteria_first_observed_at != null ? var.criteria_first_observed_at : []
      content {
        start = first_observed_at.value.start
        end   = first_observed_at.value.end

        dynamic "date_range" {
          for_each = first_observed_at.value.date_range != null ? [first_observed_at.value.date_range] : []
          content {
            unit  = date_range.value.unit
            value = date_range.value.value
          }
        }
      }
    }

    dynamic "generator_id" {
      for_each = var.criteria_generator_id != null ? var.criteria_generator_id : []
      content {
        comparison = generator_id.value.comparison
        value      = generator_id.value.value
      }
    }

    dynamic "id" {
      for_each = var.criteria_id != null ? var.criteria_id : []
      content {
        comparison = id.value.comparison
        value      = id.value.value
      }
    }

    dynamic "last_observed_at" {
      for_each = var.criteria_last_observed_at != null ? var.criteria_last_observed_at : []
      content {
        start = last_observed_at.value.start
        end   = last_observed_at.value.end

        dynamic "date_range" {
          for_each = last_observed_at.value.date_range != null ? [last_observed_at.value.date_range] : []
          content {
            unit  = date_range.value.unit
            value = date_range.value.value
          }
        }
      }
    }

    dynamic "note_text" {
      for_each = var.criteria_note_text != null ? var.criteria_note_text : []
      content {
        comparison = note_text.value.comparison
        value      = note_text.value.value
      }
    }

    dynamic "note_updated_at" {
      for_each = var.criteria_note_updated_at != null ? var.criteria_note_updated_at : []
      content {
        start = note_updated_at.value.start
        end   = note_updated_at.value.end

        dynamic "date_range" {
          for_each = note_updated_at.value.date_range != null ? [note_updated_at.value.date_range] : []
          content {
            unit  = date_range.value.unit
            value = date_range.value.value
          }
        }
      }
    }

    dynamic "note_updated_by" {
      for_each = var.criteria_note_updated_by != null ? var.criteria_note_updated_by : []
      content {
        comparison = note_updated_by.value.comparison
        value      = note_updated_by.value.value
      }
    }

    dynamic "product_arn" {
      for_each = var.criteria_product_arn != null ? var.criteria_product_arn : []
      content {
        comparison = product_arn.value.comparison
        value      = product_arn.value.value
      }
    }

    dynamic "product_name" {
      for_each = var.criteria_product_name != null ? var.criteria_product_name : []
      content {
        comparison = product_name.value.comparison
        value      = product_name.value.value
      }
    }

    dynamic "record_state" {
      for_each = var.criteria_record_state != null ? var.criteria_record_state : []
      content {
        comparison = record_state.value.comparison
        value      = record_state.value.value
      }
    }

    dynamic "related_findings_id" {
      for_each = var.criteria_related_findings_id != null ? var.criteria_related_findings_id : []
      content {
        comparison = related_findings_id.value.comparison
        value      = related_findings_id.value.value
      }
    }

    dynamic "related_findings_product_arn" {
      for_each = var.criteria_related_findings_product_arn != null ? var.criteria_related_findings_product_arn : []
      content {
        comparison = related_findings_product_arn.value.comparison
        value      = related_findings_product_arn.value.value
      }
    }

    dynamic "resource_application_arn" {
      for_each = var.criteria_resource_application_arn != null ? var.criteria_resource_application_arn : []
      content {
        comparison = resource_application_arn.value.comparison
        value      = resource_application_arn.value.value
      }
    }

    dynamic "resource_application_name" {
      for_each = var.criteria_resource_application_name != null ? var.criteria_resource_application_name : []
      content {
        comparison = resource_application_name.value.comparison
        value      = resource_application_name.value.value
      }
    }

    dynamic "resource_details_other" {
      for_each = var.criteria_resource_details_other != null ? var.criteria_resource_details_other : []
      content {
        comparison = resource_details_other.value.comparison
        key        = resource_details_other.value.key
        value      = resource_details_other.value.value
      }
    }

    dynamic "resource_id" {
      for_each = var.criteria_resource_id != null ? var.criteria_resource_id : []
      content {
        comparison = resource_id.value.comparison
        value      = resource_id.value.value
      }
    }

    dynamic "resource_partition" {
      for_each = var.criteria_resource_partition != null ? var.criteria_resource_partition : []
      content {
        comparison = resource_partition.value.comparison
        value      = resource_partition.value.value
      }
    }

    dynamic "resource_region" {
      for_each = var.criteria_resource_region != null ? var.criteria_resource_region : []
      content {
        comparison = resource_region.value.comparison
        value      = resource_region.value.value
      }
    }

    dynamic "resource_tags" {
      for_each = var.criteria_resource_tags != null ? var.criteria_resource_tags : []
      content {
        comparison = resource_tags.value.comparison
        key        = resource_tags.value.key
        value      = resource_tags.value.value
      }
    }

    dynamic "resource_type" {
      for_each = var.criteria_resource_type != null ? var.criteria_resource_type : []
      content {
        comparison = resource_type.value.comparison
        value      = resource_type.value.value
      }
    }

    dynamic "severity_label" {
      for_each = var.criteria_severity_label != null ? var.criteria_severity_label : []
      content {
        comparison = severity_label.value.comparison
        value      = severity_label.value.value
      }
    }

    dynamic "source_url" {
      for_each = var.criteria_source_url != null ? var.criteria_source_url : []
      content {
        comparison = source_url.value.comparison
        value      = source_url.value.value
      }
    }

    dynamic "title" {
      for_each = var.criteria_title != null ? var.criteria_title : []
      content {
        comparison = title.value.comparison
        value      = title.value.value
      }
    }

    dynamic "type" {
      for_each = var.criteria_type != null ? var.criteria_type : []
      content {
        comparison = type.value.comparison
        value      = type.value.value
      }
    }

    dynamic "updated_at" {
      for_each = var.criteria_updated_at != null ? var.criteria_updated_at : []
      content {
        start = updated_at.value.start
        end   = updated_at.value.end

        dynamic "date_range" {
          for_each = updated_at.value.date_range != null ? [updated_at.value.date_range] : []
          content {
            unit  = date_range.value.unit
            value = date_range.value.value
          }
        }
      }
    }

    dynamic "user_defined_fields" {
      for_each = var.criteria_user_defined_fields != null ? var.criteria_user_defined_fields : []
      content {
        comparison = user_defined_fields.value.comparison
        key        = user_defined_fields.value.key
        value      = user_defined_fields.value.value
      }
    }

    dynamic "verification_state" {
      for_each = var.criteria_verification_state != null ? var.criteria_verification_state : []
      content {
        comparison = verification_state.value.comparison
        value      = verification_state.value.value
      }
    }

    dynamic "workflow_status" {
      for_each = var.criteria_workflow_status != null ? var.criteria_workflow_status : []
      content {
        comparison = workflow_status.value.comparison
        value      = workflow_status.value.value
      }
    }
  }
}