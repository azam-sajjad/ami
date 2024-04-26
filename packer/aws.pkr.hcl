packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}


###########################################################
################# # VARIABLES # ###########################
variable "linux_flavor" {
  type    = string
  default = env("LINUX_FLAVOR")
}
variable "vpc_id" {
  type    = string
  default = env("VPC_ID")
}
variable "subnet_id" {
  type    = string
  default = env("SUBNET_ID")
}
variable "ami_id" {
  type    = string
  default = env("AMI_ID")
}
variable "ami_prefix" {
  type    = string
  default = env("AMI_PREFIX")
}
variable "region" {
  type    = string
  default = env("AWS_REGION")
}
variable "date" {
  type    = string
  default = env("DATE")
}
variable "dir" {
  type    = string
  default = env("DIR")
}
variable "username" {
  type    = string
  default = env("USERNAME")
}
variable "distribution" {
  type    = string
  default = env("DISTRIBUTION")
}
variable "version" {
  type    = string
  default = env("VERSION")
}

variable "PARTITIONS" {
  type    = string
  default = env("PARTITIONS")
}
variable "OPENPORTS" {
  type    = string
  default = env("OPENPORTS")
}
variable "PORT1" {
  type    = string
  default = env("PORT1")
}
variable "PORT2" {
  type    = string
  default = env("PORT2")
}
variable "IPV6" {
  type    = string
  default = env("IPV6")
}
variable "LYNIS" {
  type    = string
  default = env("LYNIS")
}
variable "LOCKDOWN" {
  type    = string
  default = env("LOCKDOWN")
}
variable "FIREWALL" {
  type    = string
  default = env("FIREWALL")
}

###########################################################

source "amazon-ebs" "main" {
  profile = "eurus-control"
  assume_role {
    role_arn = "arn:aws:iam::059516066038:role/central-managed-AdministratorAccess"
  }
  region = "${var.region}"
  ami_name = "${var.ami_prefix}-${var.distribution}${var.version}-${var.date}"
  source_ami = "${var.ami_id}"
  instance_type = "t2.micro"
  ssh_username = "${var.username}"
  vpc_id = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true
  ssh_interface = "public_ip"

  dynamic "launch_block_device_mappings" {
    for_each = var.PARTITIONS ? [1] : []
    content {
      device_name           = "/dev/sdb"
      volume_size           = 25
      volume_type           = "gp2"
      delete_on_termination = false
      virtual_name          = ""
    }
  }

  tags = {
        Name = "${var.ami_prefix}-${var.distribution}${var.version}-${var.date}"
        Permission = "Allowed"
        }
}
###########################################################


build {
    sources = ["source.amazon-ebs.main"]
    provisioner "file" {
        source = "${var.dir}"
        destination = "/home/${var.username}/ami"
    }
    provisioner "shell" {
        inline = ["sudo lsblk"]
    }
    provisioner "shell" {
        inline = ["chmod u+x /home/${var.username}/ami/scripts/${var.linux_flavor}/${var.distribution}.sh", "bash /home/${var.username}/ami/scripts/${var.linux_flavor}/${var.distribution}.sh"]
    }
    provisioner "shell" {
        inline = ["sudo mkdir -p /etc/ansible", "sudo cp /home/${var.username}/ami/ansible/ansible.cfg /etc/ansible/ansible.cfg"]
    }
    provisioner "ansible-local" {
        playbook_file = "../ansible/playbook.yml"
        extra_arguments = [
                "-v",
                "--extra-vars", "username=${var.username}",
                "--extra-vars", "cis_partitions=${var.PARTITIONS}",
                "--extra-vars", "cis_open_custom_ports=${var.OPENPORTS}",
                "--extra-vars", "cis_lynis=${var.LYNIS}",
                "--extra-vars", "cis_section99=${var.LOCKDOWN}",
                "--extra-vars", "cis_port1=${var.PORT1}",
                "--extra-vars", "cis_port2=${var.PORT2}",
                "--extra-vars", "cis_ipv6_required=${var.IPV6}",
                "--extra-vars", "cis_firewall=${var.FIREWALL}"
            ]
    }
    provisioner "shell-local" {
        inline = ["foldername1=$(date +%Y%m%d)", "foldername2=$(date +%R)", "sudo mkdir -p ${var.dir}/'$foldername'/${var.distribution}${var.version}/'$foldername2'"]
    }
    provisioner "file" {
        source = "/home/${var.username}/ansible.log"
        destination = "${var.dir}/'$foldername1'/${var.distribution}${var.version}/'$foldername2'/"
        direction = "download"
    }
    provisioner "shell" {
        inline = ["chmod u+x /home/${var.username}/ami/scripts/cleanup/${var.linux_flavor}.sh", "sudo bash /home/${var.username}/ami/scripts//cleanup/${var.linux_flavor}.sh"]
    }
    provisioner "shell" {
        inline = ["sudo rm -rf /home/${var.username}/*"]
    }
}