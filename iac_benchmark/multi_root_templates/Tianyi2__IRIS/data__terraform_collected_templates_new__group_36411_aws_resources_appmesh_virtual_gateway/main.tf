resource "aws_appmesh_virtual_gateway" "this" {
  name       = var.name
  mesh_name  = var.mesh_name
  mesh_owner = var.mesh_owner
  region     = var.region
  tags       = var.tags

  spec {
    dynamic "listener" {
      for_each = [var.spec.listener]
      content {
        port_mapping {
          port     = listener.value.port_mapping.port
          protocol = listener.value.port_mapping.protocol
        }

        dynamic "connection_pool" {
          for_each = listener.value.connection_pool != null ? [listener.value.connection_pool] : []
          content {
            dynamic "grpc" {
              for_each = connection_pool.value.grpc != null ? [connection_pool.value.grpc] : []
              content {
                max_requests = grpc.value.max_requests
              }
            }

            dynamic "http" {
              for_each = connection_pool.value.http != null ? [connection_pool.value.http] : []
              content {
                max_connections      = http.value.max_connections
                max_pending_requests = http.value.max_pending_requests
              }
            }

            dynamic "http2" {
              for_each = connection_pool.value.http2 != null ? [connection_pool.value.http2] : []
              content {
                max_requests = http2.value.max_requests
              }
            }
          }
        }

        dynamic "health_check" {
          for_each = listener.value.health_check != null ? [listener.value.health_check] : []
          content {
            healthy_threshold   = health_check.value.healthy_threshold
            interval_millis     = health_check.value.interval_millis
            protocol            = health_check.value.protocol
            timeout_millis      = health_check.value.timeout_millis
            unhealthy_threshold = health_check.value.unhealthy_threshold
            path                = health_check.value.path
            port                = health_check.value.port
          }
        }

        dynamic "tls" {
          for_each = listener.value.tls != null ? [listener.value.tls] : []
          content {
            mode = tls.value.mode

            certificate {
              dynamic "acm" {
                for_each = tls.value.certificate.acm != null ? [tls.value.certificate.acm] : []
                content {
                  certificate_arn = acm.value.certificate_arn
                }
              }

              dynamic "file" {
                for_each = tls.value.certificate.file != null ? [tls.value.certificate.file] : []
                content {
                  certificate_chain = file.value.certificate_chain
                  private_key       = file.value.private_key
                }
              }

              dynamic "sds" {
                for_each = tls.value.certificate.sds != null ? [tls.value.certificate.sds] : []
                content {
                  secret_name = sds.value.secret_name
                }
              }
            }

            dynamic "validation" {
              for_each = tls.value.validation != null ? [tls.value.validation] : []
              content {
                dynamic "subject_alternative_names" {
                  for_each = validation.value.subject_alternative_names != null ? [validation.value.subject_alternative_names] : []
                  content {
                    match {
                      exact = subject_alternative_names.value.match.exact
                    }
                  }
                }

                trust {
                  dynamic "file" {
                    for_each = validation.value.trust.file != null ? [validation.value.trust.file] : []
                    content {
                      certificate_chain = file.value.certificate_chain
                    }
                  }

                  dynamic "sds" {
                    for_each = validation.value.trust.sds != null ? [validation.value.trust.sds] : []
                    content {
                      secret_name = sds.value.secret_name
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    dynamic "backend_defaults" {
      for_each = var.spec.backend_defaults != null ? [var.spec.backend_defaults] : []
      content {
        dynamic "client_policy" {
          for_each = backend_defaults.value.client_policy != null ? [backend_defaults.value.client_policy] : []
          content {
            dynamic "tls" {
              for_each = client_policy.value.tls != null ? [client_policy.value.tls] : []
              content {
                enforce = tls.value.enforce
                ports   = tls.value.ports

                dynamic "certificate" {
                  for_each = tls.value.certificate != null ? [tls.value.certificate] : []
                  content {
                    dynamic "file" {
                      for_each = certificate.value.file != null ? [certificate.value.file] : []
                      content {
                        certificate_chain = file.value.certificate_chain
                        private_key       = file.value.private_key
                      }
                    }

                    dynamic "sds" {
                      for_each = certificate.value.sds != null ? [certificate.value.sds] : []
                      content {
                        secret_name = sds.value.secret_name
                      }
                    }
                  }
                }

                validation {
                  dynamic "subject_alternative_names" {
                    for_each = tls.value.validation.subject_alternative_names != null ? [tls.value.validation.subject_alternative_names] : []
                    content {
                      match {
                        exact = subject_alternative_names.value.match.exact
                      }
                    }
                  }

                  trust {
                    dynamic "acm" {
                      for_each = tls.value.validation.trust.acm != null ? [tls.value.validation.trust.acm] : []
                      content {
                        certificate_authority_arns = acm.value.certificate_authority_arns
                      }
                    }

                    dynamic "file" {
                      for_each = tls.value.validation.trust.file != null ? [tls.value.validation.trust.file] : []
                      content {
                        certificate_chain = file.value.certificate_chain
                      }
                    }

                    dynamic "sds" {
                      for_each = tls.value.validation.trust.sds != null ? [tls.value.validation.trust.sds] : []
                      content {
                        secret_name = sds.value.secret_name
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

    dynamic "logging" {
      for_each = var.spec.logging != null ? [var.spec.logging] : []
      content {
        dynamic "access_log" {
          for_each = logging.value.access_log != null ? [logging.value.access_log] : []
          content {
            dynamic "file" {
              for_each = access_log.value.file != null ? [access_log.value.file] : []
              content {
                path = file.value.path

                dynamic "format" {
                  for_each = file.value.format != null ? [file.value.format] : []
                  content {
                    dynamic "json" {
                      for_each = format.value.json != null ? format.value.json : []
                      content {
                        key   = json.value.key
                        value = json.value.value
                      }
                    }

                    text = format.value.text
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