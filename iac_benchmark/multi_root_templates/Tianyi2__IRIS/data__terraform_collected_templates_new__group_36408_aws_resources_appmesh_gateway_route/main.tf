resource "aws_appmesh_gateway_route" "this" {
  region               = var.region
  name                 = var.name
  mesh_name            = var.mesh_name
  virtual_gateway_name = var.virtual_gateway_name
  mesh_owner           = var.mesh_owner
  tags                 = var.tags

  spec {
    priority = var.spec_priority

    dynamic "grpc_route" {
      for_each = var.grpc_route != null ? [var.grpc_route] : []
      content {
        action {
          target {
            port = grpc_route.value.action.target.port
            virtual_service {
              virtual_service_name = grpc_route.value.action.target.virtual_service.virtual_service_name
            }
          }
        }
        match {
          service_name = grpc_route.value.match.service_name
          port         = grpc_route.value.match.port
        }
      }
    }

    dynamic "http_route" {
      for_each = var.http_route != null ? [var.http_route] : []
      content {
        action {
          target {
            port = http_route.value.action.target.port
            virtual_service {
              virtual_service_name = http_route.value.action.target.virtual_service.virtual_service_name
            }
          }
          dynamic "rewrite" {
            for_each = http_route.value.action.rewrite != null ? [http_route.value.action.rewrite] : []
            content {
              dynamic "hostname" {
                for_each = rewrite.value.hostname != null ? [rewrite.value.hostname] : []
                content {
                  default_target_hostname = hostname.value.default_target_hostname
                }
              }
              dynamic "path" {
                for_each = rewrite.value.path != null ? [rewrite.value.path] : []
                content {
                  exact = path.value.exact
                }
              }
              dynamic "prefix" {
                for_each = rewrite.value.prefix != null ? [rewrite.value.prefix] : []
                content {
                  default_prefix = prefix.value.default_prefix
                  value          = prefix.value.value
                }
              }
            }
          }
        }
        match {
          port   = http_route.value.match.port
          prefix = http_route.value.match.prefix

          dynamic "header" {
            for_each = http_route.value.match.header != null ? http_route.value.match.header : []
            content {
              name   = header.value.name
              invert = header.value.invert
              dynamic "match" {
                for_each = header.value.match != null ? [header.value.match] : []
                content {
                  exact  = match.value.exact
                  prefix = match.value.prefix
                  regex  = match.value.regex
                  suffix = match.value.suffix
                  dynamic "range" {
                    for_each = match.value.range != null ? [match.value.range] : []
                    content {
                      end   = range.value.end
                      start = range.value.start
                    }
                  }
                }
              }
            }
          }

          dynamic "hostname" {
            for_each = http_route.value.match.hostname != null ? [http_route.value.match.hostname] : []
            content {
              exact  = hostname.value.exact
              suffix = hostname.value.suffix
            }
          }

          dynamic "path" {
            for_each = http_route.value.match.path != null ? [http_route.value.match.path] : []
            content {
              exact = path.value.exact
              regex = path.value.regex
            }
          }

          dynamic "query_parameter" {
            for_each = http_route.value.match.query_parameter != null ? http_route.value.match.query_parameter : []
            content {
              name = query_parameter.value.name
              dynamic "match" {
                for_each = query_parameter.value.match != null ? [query_parameter.value.match] : []
                content {
                  exact = match.value.exact
                }
              }
            }
          }
        }
      }
    }

    dynamic "http2_route" {
      for_each = var.http2_route != null ? [var.http2_route] : []
      content {
        action {
          target {
            port = http2_route.value.action.target.port
            virtual_service {
              virtual_service_name = http2_route.value.action.target.virtual_service.virtual_service_name
            }
          }
          dynamic "rewrite" {
            for_each = http2_route.value.action.rewrite != null ? [http2_route.value.action.rewrite] : []
            content {
              dynamic "hostname" {
                for_each = rewrite.value.hostname != null ? [rewrite.value.hostname] : []
                content {
                  default_target_hostname = hostname.value.default_target_hostname
                }
              }
              dynamic "path" {
                for_each = rewrite.value.path != null ? [rewrite.value.path] : []
                content {
                  exact = path.value.exact
                }
              }
              dynamic "prefix" {
                for_each = rewrite.value.prefix != null ? [rewrite.value.prefix] : []
                content {
                  default_prefix = prefix.value.default_prefix
                  value          = prefix.value.value
                }
              }
            }
          }
        }
        match {
          port   = http2_route.value.match.port
          prefix = http2_route.value.match.prefix

          dynamic "header" {
            for_each = http2_route.value.match.header != null ? http2_route.value.match.header : []
            content {
              name   = header.value.name
              invert = header.value.invert
              dynamic "match" {
                for_each = header.value.match != null ? [header.value.match] : []
                content {
                  exact  = match.value.exact
                  prefix = match.value.prefix
                  regex  = match.value.regex
                  suffix = match.value.suffix
                  dynamic "range" {
                    for_each = match.value.range != null ? [match.value.range] : []
                    content {
                      end   = range.value.end
                      start = range.value.start
                    }
                  }
                }
              }
            }
          }

          dynamic "hostname" {
            for_each = http2_route.value.match.hostname != null ? [http2_route.value.match.hostname] : []
            content {
              exact  = hostname.value.exact
              suffix = hostname.value.suffix
            }
          }

          dynamic "path" {
            for_each = http2_route.value.match.path != null ? [http2_route.value.match.path] : []
            content {
              exact = path.value.exact
              regex = path.value.regex
            }
          }

          dynamic "query_parameter" {
            for_each = http2_route.value.match.query_parameter != null ? http2_route.value.match.query_parameter : []
            content {
              name = query_parameter.value.name
              dynamic "match" {
                for_each = query_parameter.value.match != null ? [query_parameter.value.match] : []
                content {
                  exact = match.value.exact
                }
              }
            }
          }
        }
      }
    }
  }
}