resource "aws_quicksight_theme" "this" {
  aws_account_id      = var.aws_account_id
  base_theme_id       = var.base_theme_id
  name                = var.name
  theme_id            = var.theme_id
  version_description = var.version_description
  tags                = var.tags

  dynamic "permissions" {
    for_each = var.permissions != null ? var.permissions : []
    content {
      actions   = permissions.value.actions
      principal = permissions.value.principal
    }
  }

  configuration {
    dynamic "data_color_palette" {
      for_each = var.configuration.data_color_palette != null ? [var.configuration.data_color_palette] : []
      content {
        colors           = data_color_palette.value.colors
        empty_fill_color = data_color_palette.value.empty_fill_color
        min_max_gradient = data_color_palette.value.min_max_gradient
      }
    }

    dynamic "sheet" {
      for_each = var.configuration.sheet != null ? [var.configuration.sheet] : []
      content {
        dynamic "tile" {
          for_each = sheet.value.tile != null ? [sheet.value.tile] : []
          content {
            dynamic "border" {
              for_each = tile.value.border != null ? [tile.value.border] : []
              content {
                show = border.value.show
              }
            }
          }
        }

        dynamic "tile_layout" {
          for_each = sheet.value.tile_layout != null ? [sheet.value.tile_layout] : []
          content {
            dynamic "gutter" {
              for_each = tile_layout.value.gutter != null ? [tile_layout.value.gutter] : []
              content {
                show = gutter.value.show
              }
            }

            dynamic "margin" {
              for_each = tile_layout.value.margin != null ? [tile_layout.value.margin] : []
              content {
                show = margin.value.show
              }
            }
          }
        }
      }
    }

    dynamic "typography" {
      for_each = var.configuration.typography != null ? [var.configuration.typography] : []
      content {
        dynamic "font_families" {
          for_each = typography.value.font_families != null ? typography.value.font_families : []
          content {
            font_family = font_families.value.font_family
          }
        }
      }
    }

    dynamic "ui_color_palette" {
      for_each = var.configuration.ui_color_palette != null ? [var.configuration.ui_color_palette] : []
      content {
        accent               = ui_color_palette.value.accent
        accent_foreground    = ui_color_palette.value.accent_foreground
        danger               = ui_color_palette.value.danger
        danger_foreground    = ui_color_palette.value.danger_foreground
        dimension            = ui_color_palette.value.dimension
        dimension_foreground = ui_color_palette.value.dimension_foreground
        measure              = ui_color_palette.value.measure
        measure_foreground   = ui_color_palette.value.measure_foreground
        primary_background   = ui_color_palette.value.primary_background
        primary_foreground   = ui_color_palette.value.primary_foreground
        secondary_background = ui_color_palette.value.secondary_background
        secondary_foreground = ui_color_palette.value.secondary_foreground
        success              = ui_color_palette.value.success
        success_foreground   = ui_color_palette.value.success_foreground
        warning              = ui_color_palette.value.warning
        warning_foreground   = ui_color_palette.value.warning_foreground
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}