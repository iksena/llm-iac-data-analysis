output "id" {
  description = "Same as name"
  value       = aws_memorydb_cluster.this.id
}

output "arn" {
  description = "The ARN of the cluster"
  value       = aws_memorydb_cluster.this.arn
}

output "cluster_endpoint" {
  description = "The cluster configuration endpoint"
  value = {
    address = aws_memorydb_cluster.this.cluster_endpoint[0].address
    port    = aws_memorydb_cluster.this.cluster_endpoint[0].port
  }
}

output "engine_patch_version" {
  description = "Patch version number of the engine used by the cluster"
  value       = aws_memorydb_cluster.this.engine_patch_version
}

output "shards" {
  description = "Set of shards in this cluster"
  value = [
    for shard in aws_memorydb_cluster.this.shards : {
      name      = shard.name
      num_nodes = shard.num_nodes
      slots     = shard.slots
      nodes = [
        for node in shard.nodes : {
          availability_zone = node.availability_zone
          create_time       = node.create_time
          name              = node.name
          endpoint = {
            address = node.endpoint[0].address
            port    = node.endpoint[0].port
          }
        }
      ]
    }
  ]
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_memorydb_cluster.this.tags_all
}