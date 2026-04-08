/**
 * Copyright 2020 Taito United
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "digitalocean_database_cluster" "mysql" {
  count      = length(local.mysqlClusters)

  name       = local.mysqlClusters[count.index].name
  engine     = "mysql"
  size       = local.mysqlClusters[count.index].tier
  region     = var.region
  node_count = local.mysqlClusters[count.index].nodeCount

  lifecycle {
    prevent_destroy = true
  }
}
