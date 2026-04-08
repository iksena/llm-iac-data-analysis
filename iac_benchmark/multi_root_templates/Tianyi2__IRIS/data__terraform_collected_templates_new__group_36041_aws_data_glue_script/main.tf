data "aws_glue_script" "this" {
  region   = var.region
  language = var.language

  dynamic "dag_edge" {
    for_each = var.dag_edges
    content {
      source           = dag_edge.value.source
      target           = dag_edge.value.target
      target_parameter = dag_edge.value.target_parameter
    }
  }

  dynamic "dag_node" {
    for_each = var.dag_nodes
    content {
      id          = dag_node.value.id
      node_type   = dag_node.value.node_type
      line_number = dag_node.value.line_number

      dynamic "args" {
        for_each = dag_node.value.args
        content {
          name  = args.value.name
          value = args.value.value
          param = args.value.param
        }
      }
    }
  }
}