# ── awscc_ec2_placement_group_cluster_p1.tf ────────────────────────────────────
# Create cluster ec2 placement group via the 'awscc' provider

resource "awscc_ec2_placement_group" "web" {
  strategy = "cluster"
  tags = [
    {
      key   = "Modified By"
      value = "AWSCC"
    }
  ]
}


# ── awscc_ec2_placement_group_cluster_p2.tf ────────────────────────────────────
# Terraform code to create cluster ec2 placement group via the 'awscc' provider

resource "awscc_ec2_placement_group" "web" {
  strategy = "cluster"
  tags = [
    {
      key   = "Modified By"
      value = "AWSCC"
    }
  ]
}


# ── awscc_ec2_placement_group_cluster_p3.tf ────────────────────────────────────
# Write Terraform configuration that creates cluster ec2 placement group, use awscc provider

resource "awscc_ec2_placement_group" "web" {
  strategy = "cluster"
  tags = [
    {
      key   = "Modified By"
      value = "AWSCC"
    }
  ]
}


# ── awscc_ec2_placement_group_partition_p1.tf ────────────────────────────────────
# Create partition ec2 placement group via the 'awscc' provider

resource "awscc_ec2_placement_group" "web" {
  strategy        = "partition"
  partition_count = 2
  tags = [
    {
      key   = "Modified By"
      value = "AWSCC"
    }
  ]
}


# ── awscc_ec2_placement_group_partition_p2.tf ────────────────────────────────────
# Terraform code to create partition ec2 placement group via the 'awscc' provider

resource "awscc_ec2_placement_group" "web" {
  strategy        = "partition"
  partition_count = 2
  tags = [
    {
      key   = "Modified By"
      value = "AWSCC"
    }
  ]
}


# ── awscc_ec2_placement_group_partition_p3.tf ────────────────────────────────────
# Write Terraform configuration that creates partition ec2 placement group, use awscc provider

resource "awscc_ec2_placement_group" "web" {
  strategy        = "partition"
  partition_count = 2
  tags = [
    {
      key   = "Modified By"
      value = "AWSCC"
    }
  ]
}


# ── awscc_ec2_placement_group_spread_p1.tf ────────────────────────────────────
# Create spread ec2 placement group via the 'awscc' provider

resource "awscc_ec2_placement_group" "web" {
  strategy     = "spread"
  spread_level = "host"
  tags = [
    {
      key   = "Modified By"
      value = "AWSCC"
    }
  ]
}


# ── awscc_ec2_placement_group_spread_p2.tf ────────────────────────────────────
# Terraform code to create spread ec2 placement group via the 'awscc' provider

resource "awscc_ec2_placement_group" "web" {
  strategy     = "spread"
  spread_level = "host"
  tags = [
    {
      key   = "Modified By"
      value = "AWSCC"
    }
  ]
}


# ── awscc_ec2_placement_group_spread_p3.tf ────────────────────────────────────
# Write Terraform configuration that creates spread ec2 placement group, use awscc provider

resource "awscc_ec2_placement_group" "web" {
  strategy     = "spread"
  spread_level = "host"
  tags = [
    {
      key   = "Modified By"
      value = "AWSCC"
    }
  ]
}
