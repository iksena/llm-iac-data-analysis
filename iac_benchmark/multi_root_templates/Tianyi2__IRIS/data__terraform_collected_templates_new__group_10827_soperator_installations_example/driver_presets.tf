locals {
  worker_platforms_all = distinct([
    for worker in var.slurm_nodeset_workers : worker.resource.platform
  ])

  worker_platforms_preinstalled = distinct([
    for worker in var.slurm_nodeset_workers : worker.resource.platform
    if var.use_preinstalled_gpu_drivers
  ])

  worker_cuda_versions = distinct(compact([
    for worker in var.slurm_nodeset_workers :
    lookup(var.platform_cuda_versions, worker.resource.platform)
  ]))

  worker_driver_versions = distinct(compact([
    for worker in var.slurm_nodeset_workers :
    lookup(var.platform_driver_presets, worker.resource.platform)
  ]))
}

resource "terraform_data" "check_driver_presets" {
  lifecycle {
    precondition {
      condition = length(setsubtract(
        toset(local.worker_platforms_preinstalled),
        toset([for platform, preset in var.platform_driver_presets : platform if preset != null])
      )) == 0
      error_message = format(
        "Missing driver preset (cudaXX-X form) for platform(s): %s",
        join(
          ", ",
          setsubtract(
            toset(local.worker_platforms_preinstalled),
            toset([for platform, preset in var.platform_driver_presets : platform if preset != null])
          )
        )
      )
    }

    precondition {
      condition = length(setsubtract(
        toset(local.worker_platforms_all),
        toset([for platform, version in var.platform_cuda_versions : platform if version != null])
      )) == 0
      error_message = format(
        "Missing CUDA version (12.X.Y form) for platform(s): %s",
        join(
          ", ",
          setsubtract(
            toset(local.worker_platforms_all),
            toset([for platform, version in var.platform_cuda_versions : platform if version != null])
          )
        )
      )
    }

    precondition {
      condition = length(local.worker_cuda_versions) <= 1
      error_message = format(
        "All worker nodesets must use the same CUDA version. Found: %s",
        join(", ", local.worker_cuda_versions)
      )
    }

    precondition {
      condition = length(local.worker_driver_versions) <= 1
      error_message = format(
        "All worker nodesets must use the same driver preset versions. Found: %s",
        join(", ", local.worker_driver_versions)
      )
    }
  }
}
