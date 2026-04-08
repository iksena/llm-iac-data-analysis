output "auto_recovery_supported" {
  description = "true if auto recovery is supported"
  value       = data.aws_ec2_instance_type.this.auto_recovery_supported
}

output "bandwidth_weightings" {
  description = "A set of strings of valid settings for configurable bandwidth weighting, if supported"
  value       = data.aws_ec2_instance_type.this.bandwidth_weightings
}

output "bare_metal" {
  description = "true if it is a bare metal instance type"
  value       = data.aws_ec2_instance_type.this.bare_metal
}

output "boot_modes" {
  description = "A set of strings of supported boot modes"
  value       = data.aws_ec2_instance_type.this.boot_modes
}

output "burstable_performance_supported" {
  description = "true if the instance type is a burstable performance instance type"
  value       = data.aws_ec2_instance_type.this.burstable_performance_supported
}

output "current_generation" {
  description = "true if the instance type is a current generation"
  value       = data.aws_ec2_instance_type.this.current_generation
}

output "dedicated_hosts_supported" {
  description = "true if Dedicated Hosts are supported on the instance type"
  value       = data.aws_ec2_instance_type.this.dedicated_hosts_supported
}

output "default_cores" {
  description = "Default number of cores for the instance type"
  value       = data.aws_ec2_instance_type.this.default_cores
}

output "default_network_card_index" {
  description = "The index of the default network card, starting at 0"
  value       = data.aws_ec2_instance_type.this.default_network_card_index
}

output "default_threads_per_core" {
  description = "The default number of threads per core for the instance type"
  value       = data.aws_ec2_instance_type.this.default_threads_per_core
}

output "default_vcpus" {
  description = "Default number of vCPUs for the instance type"
  value       = data.aws_ec2_instance_type.this.default_vcpus
}

output "ebs_encryption_support" {
  description = "Indicates whether Amazon EBS encryption is supported"
  value       = data.aws_ec2_instance_type.this.ebs_encryption_support
}

output "ebs_nvme_support" {
  description = "Whether non-volatile memory express (NVMe) is supported"
  value       = data.aws_ec2_instance_type.this.ebs_nvme_support
}

output "ebs_optimized_support" {
  description = "Indicates that the instance type is Amazon EBS-optimized"
  value       = data.aws_ec2_instance_type.this.ebs_optimized_support
}

output "ebs_performance_baseline_bandwidth" {
  description = "The baseline bandwidth performance for an EBS-optimized instance type, in Mbps"
  value       = data.aws_ec2_instance_type.this.ebs_performance_baseline_bandwidth
}

output "ebs_performance_baseline_iops" {
  description = "The baseline input/output storage operations per seconds for an EBS-optimized instance type"
  value       = data.aws_ec2_instance_type.this.ebs_performance_baseline_iops
}

output "ebs_performance_baseline_throughput" {
  description = "The baseline throughput performance for an EBS-optimized instance type, in MBps"
  value       = data.aws_ec2_instance_type.this.ebs_performance_baseline_throughput
}

output "ebs_performance_maximum_bandwidth" {
  description = "The maximum bandwidth performance for an EBS-optimized instance type, in Mbps"
  value       = data.aws_ec2_instance_type.this.ebs_performance_maximum_bandwidth
}

output "ebs_performance_maximum_iops" {
  description = "The maximum input/output storage operations per second for an EBS-optimized instance type"
  value       = data.aws_ec2_instance_type.this.ebs_performance_maximum_iops
}

output "ebs_performance_maximum_throughput" {
  description = "The maximum throughput performance for an EBS-optimized instance type, in MBps"
  value       = data.aws_ec2_instance_type.this.ebs_performance_maximum_throughput
}

output "efa_maximum_interfaces" {
  description = "The maximum number of Elastic Fabric Adapters for the instance type"
  value       = data.aws_ec2_instance_type.this.efa_maximum_interfaces
}

output "efa_supported" {
  description = "true if Elastic Fabric Adapter (EFA) is supported"
  value       = data.aws_ec2_instance_type.this.efa_supported
}

output "ena_srd_supported" {
  description = "true if the instance type supports ENA Express"
  value       = data.aws_ec2_instance_type.this.ena_srd_supported
}

output "ena_support" {
  description = "Indicates whether Elastic Network Adapter (ENA) is supported, required, or unsupported"
  value       = data.aws_ec2_instance_type.this.ena_support
}

output "encryption_in_transit_supported" {
  description = "true if encryption in-transit between instances is supported"
  value       = data.aws_ec2_instance_type.this.encryption_in_transit_supported
}

output "fpgas" {
  description = "Describes the FPGA accelerator settings for the instance type"
  value       = data.aws_ec2_instance_type.this.fpgas
}

output "free_tier_eligible" {
  description = "true if the instance type is eligible for the free tier"
  value       = data.aws_ec2_instance_type.this.free_tier_eligible
}

output "gpus" {
  description = "Describes the GPU accelerators for the instance type"
  value       = data.aws_ec2_instance_type.this.gpus
}

output "hibernation_supported" {
  description = "true if On-Demand hibernation is supported"
  value       = data.aws_ec2_instance_type.this.hibernation_supported
}

output "hypervisor" {
  description = "Hypervisor used for the instance type"
  value       = data.aws_ec2_instance_type.this.hypervisor
}

output "inference_accelerators" {
  description = "Describes the Inference accelerators for the instance type"
  value       = data.aws_ec2_instance_type.this.inference_accelerators
}

output "instance_disks" {
  description = "Describes the disks for the instance type"
  value       = data.aws_ec2_instance_type.this.instance_disks
}

output "instance_storage_supported" {
  description = "true if instance storage is supported"
  value       = data.aws_ec2_instance_type.this.instance_storage_supported
}

output "instance_type" {
  description = "Instance type"
  value       = data.aws_ec2_instance_type.this.instance_type
}

output "ipv6_supported" {
  description = "true if IPv6 is supported"
  value       = data.aws_ec2_instance_type.this.ipv6_supported
}

output "maximum_ipv4_addresses_per_interface" {
  description = "The maximum number of IPv4 addresses per network interface"
  value       = data.aws_ec2_instance_type.this.maximum_ipv4_addresses_per_interface
}

output "maximum_ipv6_addresses_per_interface" {
  description = "The maximum number of IPv6 addresses per network interface"
  value       = data.aws_ec2_instance_type.this.maximum_ipv6_addresses_per_interface
}

output "maximum_network_cards" {
  description = "The maximum number of physical network cards that can be allocated to the instance"
  value       = data.aws_ec2_instance_type.this.maximum_network_cards
}

output "maximum_network_interfaces" {
  description = "The maximum number of network interfaces for the instance type"
  value       = data.aws_ec2_instance_type.this.maximum_network_interfaces
}

output "media_accelerators" {
  description = "Describes the media accelerator settings for the instance type"
  value       = data.aws_ec2_instance_type.this.media_accelerators
}

output "memory_size" {
  description = "Size of the instance memory, in MiB"
  value       = data.aws_ec2_instance_type.this.memory_size
}

output "network_cards" {
  description = "Describes the network cards for the instance type"
  value       = data.aws_ec2_instance_type.this.network_cards
}

output "network_performance" {
  description = "Describes the network performance"
  value       = data.aws_ec2_instance_type.this.network_performance
}

output "neuron_devices" {
  description = "Describes the Neuron accelerator settings for the instance type"
  value       = data.aws_ec2_instance_type.this.neuron_devices
}

output "nitro_enclaves_support" {
  description = "Indicates whether Nitro Enclaves is supported or unsupported"
  value       = data.aws_ec2_instance_type.this.nitro_enclaves_support
}

output "nitro_tpm_support" {
  description = "Indicates whether NitroTPM is supported or unsupported"
  value       = data.aws_ec2_instance_type.this.nitro_tpm_support
}

output "nitro_tpm_supported_versions" {
  description = "A set of strings indicating the supported NitroTPM versions"
  value       = data.aws_ec2_instance_type.this.nitro_tpm_supported_versions
}

output "phc_support" {
  description = "true if a local Precision Time Protocol (PTP) hardware clock (PHC) is supported"
  value       = data.aws_ec2_instance_type.this.phc_support
}

output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_ec2_instance_type.this.region
}

output "supported_architectures" {
  description = "A list of strings of architectures supported by the instance type"
  value       = data.aws_ec2_instance_type.this.supported_architectures
}

output "supported_cpu_features" {
  description = "A set of strings indicating supported CPU features"
  value       = data.aws_ec2_instance_type.this.supported_cpu_features
}

output "supported_placement_strategies" {
  description = "A list of supported placement groups types"
  value       = data.aws_ec2_instance_type.this.supported_placement_strategies
}

output "supported_root_device_types" {
  description = "A list of supported root device types"
  value       = data.aws_ec2_instance_type.this.supported_root_device_types
}

output "supported_usages_classes" {
  description = "A list of supported usage classes. Usage classes are spot, on-demand, or capacity-block"
  value       = data.aws_ec2_instance_type.this.supported_usages_classes
}

output "supported_virtualization_types" {
  description = "The supported virtualization types"
  value       = data.aws_ec2_instance_type.this.supported_virtualization_types
}

output "sustained_clock_speed" {
  description = "The speed of the processor, in GHz"
  value       = data.aws_ec2_instance_type.this.sustained_clock_speed
}

output "total_fpga_memory" {
  description = "Total memory of all FPGA accelerators for the instance type (in MiB)"
  value       = data.aws_ec2_instance_type.this.total_fpga_memory
}

output "total_gpu_memory" {
  description = "Total size of the memory for the GPU accelerators for the instance type (in MiB)"
  value       = data.aws_ec2_instance_type.this.total_gpu_memory
}

output "total_inference_memory" {
  description = "The total size of the memory for the neuron accelerators for the instance type (in MiB)"
  value       = data.aws_ec2_instance_type.this.total_inference_memory
}

output "total_instance_storage" {
  description = "The total size of the instance disks, in GB"
  value       = data.aws_ec2_instance_type.this.total_instance_storage
}

output "total_media_memory" {
  description = "The total size of the memory for the media accelerators for the instance type (in MiB)"
  value       = data.aws_ec2_instance_type.this.total_media_memory
}

output "total_neuron_device_memory" {
  description = "The total size of the memory for the neuron accelerators for the instance type (in MiB)"
  value       = data.aws_ec2_instance_type.this.total_neuron_device_memory
}

output "valid_cores" {
  description = "List of the valid number of cores that can be configured for the instance type"
  value       = data.aws_ec2_instance_type.this.valid_cores
}

output "valid_threads_per_core" {
  description = "List of the valid number of threads per core that can be configured for the instance type"
  value       = data.aws_ec2_instance_type.this.valid_threads_per_core
}