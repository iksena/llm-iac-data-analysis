output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "latest_amazon_linux_ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "latest_macos" {
  value = data.aws_ami.latest_macos.id
}

output "latest_windows_2022" {
  value = data.aws_ami.latest_windows.id
}
