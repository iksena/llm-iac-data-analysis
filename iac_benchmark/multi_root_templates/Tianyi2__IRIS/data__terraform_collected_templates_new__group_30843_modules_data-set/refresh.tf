locals {
  refresh_types = {
    "FULL"        = "FULL_REFRESH"
    "INCREMENTAL" = "INCREMENTAL_REFRESH"
  }
}


###################################################
# Refresh Schedules of QuickSight Data Set
###################################################

resource "aws_quicksight_refresh_schedule" "this" {
  for_each = {
    for schedule in var.refresh_schedules :
    schedule.id => schedule
  }

  region = aws_quicksight_data_set.this.region

  aws_account_id = local.account_id

  data_set_id = aws_quicksight_data_set.this.data_set_id
  schedule_id = each.key

  schedule {
    refresh_type          = local.refresh_types[each.value.refresh_type]
    start_after_date_time = each.value.start_at

    dynamic "schedule_frequency" {
      for_each = [each.value.schedule_frequency]
      iterator = schedule_frequency

      content {
        timezone = schedule_frequency.value.timezone
        interval = schedule_frequency.value.interval
        time_of_the_day = (!contains(["HOURLY"], schedule_frequency.value.interval)
          ? schedule_frequency.value.time_of_day
          : null
        )

        dynamic "refresh_on_day" {
          for_each = (contains(["WEEKLY", "MONTHLY"], schedule_frequency.value.interval)
            ? ["go"]
            : []
          )

          content {
            day_of_week  = schedule_frequency.value.day_of_week
            day_of_month = schedule_frequency.value.day_of_month
          }
        }
      }
    }
  }
}


###################################################
# Refresh Ingestions of QuickSight Data Set
###################################################

resource "aws_quicksight_ingestion" "this" {
  for_each = {
    for ingestion in var.refresh_ingestions :
    ingestion.id => ingestion
  }

  region = aws_quicksight_data_set.this.region

  aws_account_id = local.account_id

  data_set_id  = aws_quicksight_data_set.this.data_set_id
  ingestion_id = each.key

  ingestion_type = local.refresh_types[each.value.refresh_type]
}
