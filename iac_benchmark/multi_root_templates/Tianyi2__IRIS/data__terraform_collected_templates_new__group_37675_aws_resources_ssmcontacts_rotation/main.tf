resource "aws_ssmcontacts_rotation" "this" {
  contact_ids  = var.contact_ids
  name         = var.name
  time_zone_id = var.time_zone_id

  recurrence {
    number_of_on_calls    = var.recurrence.number_of_on_calls
    recurrence_multiplier = var.recurrence.recurrence_multiplier

    dynamic "daily_settings" {
      for_each = var.recurrence.daily_settings != null ? [var.recurrence.daily_settings] : []
      content {
        hour_of_day    = daily_settings.value.hour_of_day
        minute_of_hour = daily_settings.value.minute_of_hour
      }
    }

    dynamic "monthly_settings" {
      for_each = var.recurrence.monthly_settings != null ? var.recurrence.monthly_settings : []
      content {
        day_of_month = monthly_settings.value.day_of_month
        hand_off_time {
          hour_of_day    = monthly_settings.value.hand_off_time.hour_of_day
          minute_of_hour = monthly_settings.value.hand_off_time.minute_of_hour
        }
      }
    }

    dynamic "weekly_settings" {
      for_each = var.recurrence.weekly_settings != null ? var.recurrence.weekly_settings : []
      content {
        day_of_week = weekly_settings.value.day_of_week
        hand_off_time {
          hour_of_day    = weekly_settings.value.hand_off_time.hour_of_day
          minute_of_hour = weekly_settings.value.hand_off_time.minute_of_hour
        }
      }
    }

    dynamic "shift_coverages" {
      for_each = var.recurrence.shift_coverages != null ? var.recurrence.shift_coverages : []
      content {
        map_block_key = shift_coverages.value.map_block_key
        dynamic "coverage_times" {
          for_each = shift_coverages.value.coverage_times
          content {
            start {
              hour_of_day    = coverage_times.value.start.hour_of_day
              minute_of_hour = coverage_times.value.start.minute_of_hour
            }
            end {
              hour_of_day    = coverage_times.value.end.hour_of_day
              minute_of_hour = coverage_times.value.end.minute_of_hour
            }
          }
        }
      }
    }
  }

  region     = var.region
  start_time = var.start_time
  tags       = var.tags
}