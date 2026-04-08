output "arn" {
  description = "ARN of the theme."
  value       = data.aws_quicksight_theme.this.arn
}

output "base_theme_id" {
  description = "The ID of the theme that a custom theme will inherit from. All themes inherit from one of the starting themes defined by Amazon QuickSight."
  value       = data.aws_quicksight_theme.this.base_theme_id
}

output "configuration" {
  description = "The theme configuration, which contains the theme display properties."
  value       = data.aws_quicksight_theme.this.configuration
}

output "created_time" {
  description = "The time that the theme was created."
  value       = data.aws_quicksight_theme.this.created_time
}

output "id" {
  description = "A comma-delimited string joining AWS account ID and theme ID."
  value       = data.aws_quicksight_theme.this.id
}

output "last_updated_time" {
  description = "The time that the theme was last updated."
  value       = data.aws_quicksight_theme.this.last_updated_time
}

output "name" {
  description = "Display name of the theme."
  value       = data.aws_quicksight_theme.this.name
}

output "permissions" {
  description = "A set of resource permissions on the theme."
  value       = data.aws_quicksight_theme.this.permissions
}

output "status" {
  description = "The theme creation status."
  value       = data.aws_quicksight_theme.this.status
}

output "tags" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = data.aws_quicksight_theme.this.tags
}

output "version_description" {
  description = "A description of the current theme version being created/updated."
  value       = data.aws_quicksight_theme.this.version_description
}

output "version_number" {
  description = "The version number of the theme version."
  value       = data.aws_quicksight_theme.this.version_number
}

# Nested configuration outputs for easier access

output "data_color_palette" {
  description = "Color properties that apply to chart data colors."
  value       = try(data.aws_quicksight_theme.this.configuration[0].data_color_palette, null)
}

output "data_color_palette_colors" {
  description = "List of hexadecimal codes for the colors."
  value       = try(data.aws_quicksight_theme.this.configuration[0].data_color_palette[0].colors, null)
}

output "data_color_palette_empty_fill_color" {
  description = "The hexadecimal code of a color that applies to charts where a lack of data is highlighted."
  value       = try(data.aws_quicksight_theme.this.configuration[0].data_color_palette[0].empty_fill_color, null)
}

output "data_color_palette_min_max_gradient" {
  description = "The minimum and maximum hexadecimal codes that describe a color gradient."
  value       = try(data.aws_quicksight_theme.this.configuration[0].data_color_palette[0].min_max_gradient, null)
}

output "sheet" {
  description = "Display options related to sheets."
  value       = try(data.aws_quicksight_theme.this.configuration[0].sheet, null)
}

output "sheet_tile" {
  description = "The display options for tiles."
  value       = try(data.aws_quicksight_theme.this.configuration[0].sheet[0].tile, null)
}

output "sheet_tile_border" {
  description = "The border around a tile."
  value       = try(data.aws_quicksight_theme.this.configuration[0].sheet[0].tile[0].border, null)
}

output "sheet_tile_border_show" {
  description = "The option to enable display of borders for visuals."
  value       = try(data.aws_quicksight_theme.this.configuration[0].sheet[0].tile[0].border[0].show, null)
}

output "sheet_tile_layout" {
  description = "The layout options for tiles."
  value       = try(data.aws_quicksight_theme.this.configuration[0].sheet[0].tile_layout, null)
}

output "sheet_tile_layout_gutter" {
  description = "The gutter settings that apply between tiles."
  value       = try(data.aws_quicksight_theme.this.configuration[0].sheet[0].tile_layout[0].gutter, null)
}

output "sheet_tile_layout_gutter_show" {
  description = "This Boolean value controls whether to display a gutter space between sheet tiles."
  value       = try(data.aws_quicksight_theme.this.configuration[0].sheet[0].tile_layout[0].gutter[0].show, null)
}

output "sheet_tile_layout_margin" {
  description = "The margin settings that apply around the outside edge of sheets."
  value       = try(data.aws_quicksight_theme.this.configuration[0].sheet[0].tile_layout[0].margin, null)
}

output "sheet_tile_layout_margin_show" {
  description = "This Boolean value controls whether to display sheet margins."
  value       = try(data.aws_quicksight_theme.this.configuration[0].sheet[0].tile_layout[0].margin[0].show, null)
}

output "typography" {
  description = "Determines the typography options."
  value       = try(data.aws_quicksight_theme.this.configuration[0].typography, null)
}

output "typography_font_families" {
  description = "Determines the list of font families."
  value       = try(data.aws_quicksight_theme.this.configuration[0].typography[0].font_families, null)
}

output "typography_font_families_font_family" {
  description = "Font family names."
  value       = try([for ff in data.aws_quicksight_theme.this.configuration[0].typography[0].font_families : ff.font_family], null)
}

output "ui_color_palette" {
  description = "Color properties that apply to the UI and to charts, excluding the colors that apply to data."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette, null)
}

output "ui_color_palette_accent" {
  description = "Color (hexadecimal) that applies to selected states and buttons."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].accent, null)
}

output "ui_color_palette_accent_foreground" {
  description = "Color (hexadecimal) that applies to any text or other elements that appear over the accent color."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].accent_foreground, null)
}

output "ui_color_palette_danger" {
  description = "Color (hexadecimal) that applies to error messages."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].danger, null)
}

output "ui_color_palette_danger_foreground" {
  description = "Color (hexadecimal) that applies to any text or other elements that appear over the error color."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].danger_foreground, null)
}

output "ui_color_palette_dimension" {
  description = "Color (hexadecimal) that applies to the names of fields that are identified as dimensions."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].dimension, null)
}

output "ui_color_palette_dimension_foreground" {
  description = "Color (hexadecimal) that applies to any text or other elements that appear over the dimension color."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].dimension_foreground, null)
}

output "ui_color_palette_measure" {
  description = "Color (hexadecimal) that applies to the names of fields that are identified as measures."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].measure, null)
}

output "ui_color_palette_measure_foreground" {
  description = "Color (hexadecimal) that applies to any text or other elements that appear over the measure color."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].measure_foreground, null)
}

output "ui_color_palette_primary_background" {
  description = "Color (hexadecimal) that applies to visuals and other high emphasis UI."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].primary_background, null)
}

output "ui_color_palette_primary_foreground" {
  description = "Color (hexadecimal) of text and other foreground elements that appear over the primary background regions, such as grid lines, borders, table banding, icons, and so on."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].primary_foreground, null)
}

output "ui_color_palette_secondary_background" {
  description = "Color (hexadecimal) that applies to the sheet background and sheet controls."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].secondary_background, null)
}

output "ui_color_palette_secondary_foreground" {
  description = "Color (hexadecimal) that applies to any sheet title, sheet control text, or UI that appears over the secondary background."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].secondary_foreground, null)
}

output "ui_color_palette_success" {
  description = "Color (hexadecimal) that applies to success messages, for example the check mark for a successful download."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].success, null)
}

output "ui_color_palette_success_foreground" {
  description = "Color (hexadecimal) that applies to any text or other elements that appear over the success color."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].success_foreground, null)
}

output "ui_color_palette_warning" {
  description = "Color (hexadecimal) that applies to warning and informational messages."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].warning, null)
}

output "ui_color_palette_warning_foreground" {
  description = "Color (hexadecimal) that applies to any text or other elements that appear over the warning color."
  value       = try(data.aws_quicksight_theme.this.configuration[0].ui_color_palette[0].warning_foreground, null)
}

output "permissions_actions" {
  description = "List of IAM actions to grant or revoke permissions on."
  value       = try([for p in data.aws_quicksight_theme.this.permissions : p.actions], null)
}

output "permissions_principal" {
  description = "ARN of the principal."
  value       = try([for p in data.aws_quicksight_theme.this.permissions : p.principal], null)
}