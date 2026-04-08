resource "aws_appmesh_route" "this" {
  region              = var.region
  name                = var.name
  mesh_name           = var.mesh_name
  mesh_owner          = var.mesh_owner
  virtual_router_name = var.virtual_router_name
  tags                = var.tags

  spec {
    priority = var.spec.priority

    dynamic "grpc_route" {
      for_each = var.spec.grpc_route != null ? [var.spec.grpc_route] : []
      content {
        action {
          dynamic "weighted_target" {
            for_each = grpc_route.value.action.weighted_target
            content {
              virtual_node = weighted_target.value.virtual_node
              weight       = weighted_target.value.weight
              port         = weighted_target.value.port
            }
          }
        }

        match {
          method_name  = grpc_route.value.match.method_name
          service_name = grpc_route.value.match.service_name
          port         = grpc_route.value.match.port

          dynamic "metadata" {
            for_each = grpc_route.value.match.metadata != null ? grpc_route.value.match.metadata : []
            content {
              name   = metadata.value.name
              invert = metadata.value.invert

              dynamic "match" {
                for_each = metadata.value.match != null ? [metadata.value.match] : []
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
        }

        dynamic "retry_policy" {
          for_each = grpc_route.value.retry_policy != null ? [grpc_route.value.retry_policy] : []
          content {
            grpc_retry_events = retry_policy.value.grpc_retry_events
            http_retry_events = retry_policy.value.http_retry_events
            max_retries       = retry_policy.value.max_retries
            tcp_retry_events  = retry_policy.value.tcp_retry_events

            per_retry_timeout {
              unit  = retry_policy.value.per_retry_timeout.unit
              value = retry_policy.value.per_retry_timeout.value
            }
          }
        }

        dynamic "timeout" {
          for_each = grpc_route.value.timeout != null ? [grpc_route.value.timeout] : []
          content {
            dynamic "idle" {
              for_each = timeout.value.idle != null ? [timeout.value.idle] : []
              content {
                unit  = idle.value.unit
                value = idle.value.value
              }
            }

            dynamic "per_request" {
              for_each = timeout.value.per_request != null ? [timeout.value.per_request] : []
              content {
                unit  = per_request.value.unit
                value = per_request.value.value
              }
            }
          }
        }
      }
    }

    dynamic "http2_route" {
      for_each = var.spec.http2_route != null ? [var.spec.http2_route] : []
      content {
        action {
          dynamic "weighted_target" {
            for_each = http2_route.value.action.weighted_target
            content {
              virtual_node = weighted_target.value.virtual_node
              weight       = weighted_target.value.weight
              port         = weighted_target.value.port
            }
          }
        }

        match {
          prefix = http2_route.value.match.prefix
          port   = http2_route.value.match.port
          method = http2_route.value.match.method
          scheme = http2_route.value.match.scheme

          dynamic "path" {
            for_each = http2_route.value.match.path != null ? [http2_route.value.match.path] : []
            content {
              exact = path.value.exact
              regex = path.value.regex
            }
          }

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

        dynamic "retry_policy" {
          for_each = http2_route.value.retry_policy != null ? [http2_route.value.retry_policy] : []
          content {
            http_retry_events = retry_policy.value.http_retry_events
            max_retries       = retry_policy.value.max_retries
            tcp_retry_events  = retry_policy.value.tcp_retry_events

            per_retry_timeout {
              unit  = retry_policy.value.per_retry_timeout.unit
              value = retry_policy.value.per_retry_timeout.value
            }
          }
        }

        dynamic "timeout" {
          for_each = http2_route.value.timeout != null ? [http2_route.value.timeout] : []
          content {
            dynamic "idle" {
              for_each = timeout.value.idle != null ? [timeout.value.idle] : []
              content {
                unit  = idle.value.unit
                value = idle.value.value
              }
            }

            dynamic "per_request" {
              for_each = timeout.value.per_request != null ? [timeout.value.per_request] : []
              content {
                unit  = per_request.value.unit
                value = per_request.value.value
              }
            }
          }
        }
      }
    }

    dynamic "http_route" {
      for_each = var.spec.http_route != null ? [var.spec.http_route] : []
      content {
        action {
          dynamic "weighted_target" {
            for_each = http_route.value.action.weighted_target
            content {
              virtual_node = weighted_target.value.virtual_node
              weight       = weighted_target.value.weight
              port         = weighted_target.value.port
            }
          }
        }

        match {
          prefix = http_route.value.match.prefix
          port   = http_route.value.match.port
          method = http_route.value.match.method
          scheme = http_route.value.match.scheme

          dynamic "path" {
            for_each = http_route.value.match.path != null ? [http_route.value.match.path] : []
            content {
              exact = path.value.exact
              regex = path.value.regex
            }
          }

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

        dynamic "retry_policy" {
          for_each = http_route.value.retry_policy != null ? [http_route.value.retry_policy] : []
          content {
            http_retry_events = retry_policy.value.http_retry_events
            max_retries       = retry_policy.value.max_retries
            tcp_retry_events  = retry_policy.value.tcp_retry_events

            per_retry_timeout {
              unit  = retry_policy.value.per_retry_timeout.unit
              value = retry_policy.value.per_retry_timeout.value
            }
          }
        }

        dynamic "timeout" {
          for_each = http_route.value.timeout != null ? [http_route.value.timeout] : []
          content {
            dynamic "idle" {
              for_each = timeout.value.idle != null ? [timeout.value.idle] : []
              content {
                unit  = idle.value.unit
                value = idle.value.value
              }
            }

            dynamic "per_request" {
              for_each = timeout.value.per_request != null ? [timeout.value.per_request] : []
              content {
                unit  = per_request.value.unit
                value = per_request.value.value
              }
            }
          }
        }
      }
    }

    dynamic "tcp_route" {
      for_each = var.spec.tcp_route != null ? [var.spec.tcp_route] : []
      content {
        action {
          dynamic "weighted_target" {
            for_each = tcp_route.value.action.weighted_target
            content {
              virtual_node = weighted_target.value.virtual_node
              weight       = weighted_target.value.weight
              port         = weighted_target.value.port
            }
          }
        }

        dynamic "timeout" {
          for_each = tcp_route.value.timeout != null ? [tcp_route.value.timeout] : []
          content {
            dynamic "idle" {
              for_each = timeout.value.idle != null ? [timeout.value.idle] : []
              content {
                unit  = idle.value.unit
                value = idle.value.value
              }
            }
          }
        }
      }
    }
  }
}