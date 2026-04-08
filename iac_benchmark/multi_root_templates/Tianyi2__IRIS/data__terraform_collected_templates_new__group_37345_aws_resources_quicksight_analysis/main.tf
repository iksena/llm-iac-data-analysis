resource "aws_quicksight_data_set" "dataset" {
  data_set_id = "example-dataset-id"
  name        = "example-dataset"
  import_mode = "SPICE"

  physical_table_map {
    physical_table_map_id = "example"
    s3_source {
      data_source_arn = "arn:aws:quicksight:us-east-1:123456789012:datasource/example"
      upload_settings {
        format = "CSV"
      }
      input_columns {
        name = "Column1"
        type = "STRING"
      }
    }
  }
}

resource "aws_quicksight_analysis" "example" {
  analysis_id = "example-id"
  name        = "example-name"
  definition {
    data_set_identifiers_declarations {
      data_set_arn = aws_quicksight_data_set.dataset.arn
      identifier   = "1"
    }
    sheets {
      title    = "Example"
      sheet_id = "Example1"
      visuals {
        line_chart_visual {
          visual_id = "LineChart"
          title {
            format_text {
              plain_text = "Line Chart Example"
            }
          }
          chart_configuration {
            field_wells {
              line_chart_aggregated_field_wells {
                category {
                  categorical_dimension_field {
                    field_id = "1"
                    column {
                      data_set_identifier = "1"
                      column_name         = "Column1"
                    }
                  }
                }
                values {
                  categorical_measure_field {
                    field_id = "2"
                    column {
                      data_set_identifier = "1"
                      column_name         = "Column1"
                    }
                    aggregation_function = "COUNT"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}