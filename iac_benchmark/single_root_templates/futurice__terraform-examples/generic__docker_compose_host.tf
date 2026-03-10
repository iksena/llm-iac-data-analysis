# ── main.tf ────────────────────────────────────
resource "null_resource" "provisioners" {
  triggers = {
    docker_host_ip      = "${var.public_ip}"                        # whenever the docker host on which docker-compose runs changes, re-run the provisioners
    reprovision_trigger = "${sha1("${local.reprovision_trigger}")}" # whenever the docker-compose config, environment etc changes, re-run the provisioners
  }

  connection {
    host        = "${var.public_ip}"
    user        = "${var.ssh_username}"
    private_key = "${var.ssh_private_key}"
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [<<EOF
command -v docker-compose && (docker-compose -v | grep ${var.docker_compose_version})
if [ "$?" -gt 0 ]; then
  sudo curl -L https://github.com/docker/compose/releases/download/${var.docker_compose_version}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose # https://docs.docker.com/compose/install/
  sudo chmod +x /usr/local/bin/docker-compose
  echo "docker-compose (${var.docker_compose_version}) installed"
else
  echo "docker-compose (${var.docker_compose_version}) already installed"
fi
EOF
    ]
  }

  provisioner "file" {
    content     = "${var.docker_compose_env}"
    destination = "/home/${var.ssh_username}/.env"
  }

  provisioner "file" {
    content     = "${var.docker_compose_yml}"
    destination = "/home/${var.ssh_username}/docker-compose.yml"
  }

  provisioner "file" {
    content     = "${var.docker_compose_override_yml}"
    destination = "/home/${var.ssh_username}/docker-compose.override.yml"
  }

  provisioner "remote-exec" {
    inline = ["${var.docker_compose_up_command}"]
  }

  provisioner "remote-exec" {
    when   = "destroy"
    inline = ["${var.docker_compose_down_command}"]
  }
}


# ── variables.tf ────────────────────────────────────
variable "public_ip" {
  description = "Public IP address of a host running docker"
}

variable "ssh_username" {
  description = "SSH username, which can be used for provisioning the host"
  default     = "ubuntu"                                                    # to match the corresponding default in aws_ec2_ebs_docker_host
}

variable "ssh_private_key" {
  description = "SSH private key, which can be used for provisioning the host"
}

variable "docker_compose_version" {
  description = "Version of docker-compose to install during provisioning (see https://github.com/docker/compose/releases)"
  default     = "1.23.2"
}

variable "docker_compose_env" {
  description = "Env-vars (in `.env` file syntax) that will be substituted into docker-compose.yml (see https://docs.docker.com/compose/environment-variables/#the-env-file)"

  # The reason for this default is that Terraform doesn't seem to want to provision an empty file
  # https://github.com/hashicorp/terraform/issues/15932
  default = "# No env-vars set"
}

variable "docker_compose_yml" {
  description = "Contents for the `docker-compose.yml` file"
}

variable "docker_compose_override_yml" {
  description = "Contents for the `docker-compose.override.yml` file (see https://docs.docker.com/compose/extends/#multiple-compose-files)"

  default = <<EOF
# Any docker-compose services defined here will be merged on top of docker-compose.yml
# See: https://docs.docker.com/compose/extends/#multiple-compose-files
version: "3"
EOF
}

variable "docker_compose_up_command" {
  description = "Command to start services with; you can customize this to do work before/after, or to disable this completely in favor of your own provisioning scripts"
  default     = "docker-compose pull --quiet && docker-compose up -d"
}

variable "docker_compose_down_command" {
  description = "Command to remove services with; will be run during un- or re-provisioning"
  default     = "docker-compose stop && docker-compose rm -f"
}


# ── outputs.tf ────────────────────────────────────
locals {
  reprovision_trigger = <<EOF
  ${var.docker_compose_version}
  ${var.docker_compose_env}
  ${var.docker_compose_yml}
  ${var.docker_compose_override_yml}
  ${var.docker_compose_up_command}
EOF
}

output "reprovision_trigger" {
  description = "Hash of all docker-compose configuration used for this host; can be used as the `reprovision_trigger` input to an `aws_ec2_ebs_docker_host` module"
  value       = "${sha1("${local.reprovision_trigger}")}"
}
