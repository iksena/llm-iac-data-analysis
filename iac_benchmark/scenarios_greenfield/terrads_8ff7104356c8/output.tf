output "eks_login" {
  value = "aws eks update-kubeconfig --name ${aws_eks_cluster.eks.id}"
}

output "node1" {
  value = "ssh -i ${aws_key_pair.key_pair.key_name}.pem root@${data.aws_instance.instance1.public_ip}"
}

output "node2" {
  value = "ssh -i ${aws_key_pair.key_pair.key_name}.pem root@${data.aws_instance.instance2.public_ip}"
}

output "persistent_volume" {
  value = aws_ebs_volume.persistent_volume.id
}