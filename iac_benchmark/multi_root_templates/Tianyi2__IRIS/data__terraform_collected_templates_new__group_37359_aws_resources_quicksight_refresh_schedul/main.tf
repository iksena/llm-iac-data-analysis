resource "aws_quicksight_refresh_schedule" "this" {
  aws_account_id = var.aws_account_id
  data_set_id    = var.data_set_id
  schedule_id    = var.schedule_id
  region         = var.region

  schedule {
    refresh_type          = var.schedule.refresh_type
    start_after_date_time = var.schedule.start_after_date_time

    schedule_frequency {
      interval        = var.schedule.schedule_frequency.interval
      time_of_the_day = var.schedule.schedule_frequency.time_of_the_day
      timezone        = var.schedule.schedule_frequency.timezone

      dynamic "refresh_on_day" {
        for_each = var.schedule.schedule_frequency.refresh_on_day != null ? [var.schedule.schedule_frequency.refresh_on_day] : []
        content {
          day_of_month = refresh_on_day.value.day_of_month
          day_of_week  = refresh_on_day.value.day_of_week
        }
      }
    }
  }
}