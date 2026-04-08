resource "aws_connect_user_hierarchy_structure" "this" {
  region      = var.region
  instance_id = var.instance_id

  hierarchy_structure {
    dynamic "level_one" {
      for_each = var.hierarchy_structure.level_one != null ? [var.hierarchy_structure.level_one] : []
      content {
        name = level_one.value.name
      }
    }

    dynamic "level_two" {
      for_each = var.hierarchy_structure.level_two != null ? [var.hierarchy_structure.level_two] : []
      content {
        name = level_two.value.name
      }
    }

    dynamic "level_three" {
      for_each = var.hierarchy_structure.level_three != null ? [var.hierarchy_structure.level_three] : []
      content {
        name = level_three.value.name
      }
    }

    dynamic "level_four" {
      for_each = var.hierarchy_structure.level_four != null ? [var.hierarchy_structure.level_four] : []
      content {
        name = level_four.value.name
      }
    }

    dynamic "level_five" {
      for_each = var.hierarchy_structure.level_five != null ? [var.hierarchy_structure.level_five] : []
      content {
        name = level_five.value.name
      }
    }
  }
}