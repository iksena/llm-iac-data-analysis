resource "aws_quicksight_custom_permissions" "this" {
  aws_account_id          = var.aws_account_id
  custom_permissions_name = var.custom_permissions_name
  region                  = var.region
  tags                    = var.tags

  capabilities {
    add_or_run_anomaly_detection_for_analyses  = var.capabilities.add_or_run_anomaly_detection_for_analyses
    create_and_update_dashboard_email_reports  = var.capabilities.create_and_update_dashboard_email_reports
    create_and_update_datasets                 = var.capabilities.create_and_update_datasets
    create_and_update_data_sources             = var.capabilities.create_and_update_data_sources
    create_and_update_themes                   = var.capabilities.create_and_update_themes
    create_and_update_threshold_alerts         = var.capabilities.create_and_update_threshold_alerts
    create_shared_folders                      = var.capabilities.create_shared_folders
    create_spice_dataset                       = var.capabilities.create_spice_dataset
    export_to_csv                              = var.capabilities.export_to_csv
    export_to_csv_in_scheduled_reports         = var.capabilities.export_to_csv_in_scheduled_reports
    export_to_excel                            = var.capabilities.export_to_excel
    export_to_excel_in_scheduled_reports       = var.capabilities.export_to_excel_in_scheduled_reports
    export_to_pdf                              = var.capabilities.export_to_pdf
    export_to_pdf_in_scheduled_reports         = var.capabilities.export_to_pdf_in_scheduled_reports
    include_content_in_scheduled_reports_email = var.capabilities.include_content_in_scheduled_reports_email
    print_reports                              = var.capabilities.print_reports
    rename_shared_folders                      = var.capabilities.rename_shared_folders
    share_analyses                             = var.capabilities.share_analyses
    share_dashboards                           = var.capabilities.share_dashboards
    share_datasets                             = var.capabilities.share_datasets
    share_data_sources                         = var.capabilities.share_data_sources
    subscribe_dashboard_email_reports          = var.capabilities.subscribe_dashboard_email_reports
    view_account_spice_capacity                = var.capabilities.view_account_spice_capacity
  }
}