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
locals {
  username = "centos"
  distribution = "centos7"              
}
###########################################################

source "amazon-ebs" "main" {
  profile = "eurus-control"
  assume_role {
    role_arn = "arn:aws:iam::059516066038:role/central-managed-AdministratorAccess"
  }
  region = "${var.region}"
  ami_name = "scaleops-${local.distribution}-${var.date}"
  source_ami = "${var.ami_id}"
  instance_type = "t2.micro"
  ssh_username = "${local.username}"
  vpc_id = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true
  ssh_interface = "public_ip"

  launch_block_device_mappings {
        device_name = "/dev/sdb"
        volume_size = 25
        volume_type = "gp2"
        delete_on_termination = false
        virtual_name = ""
        }

  tags = {
        Name = "scaleops-${local.distribution}-${var.date}"
        Permission = "Allowed"
        }
}
###########################################################


build {
    sources = ["source.amazon-ebs.main"]
    provisioner "shell-local" {
        inline = ["mkdir -p ${var.dir}/logs/${var.date}/${local.distribution}", "PACKER_LOG=1"]
    }
    provisioner "file" {
        source = "${var.dir}"
        destination = "/home/${local.username}/ami"
    }
    provisioner "shell" {
        inline = ["sudo lsblk"]
    }
    provisioner "shell" {
        inline = ["chmod u+x /home/${local.username}/ami/scripts/rpm/${local.distribution}.sh", "sudo bash /home/${local.username}/ami/scripts/rpm/${local.distribution}.sh"]
    }
    provisioner "shell" {
        inline = ["mkdir -p ~/.ansible/roles", "cp -r ~/ami/ansible/roles/* ~/.ansible/roles/"]
    }
    provisioner "ansible-local" {
        playbook_file = "../ansible/rpm-playbook.yml"
    }
    provisioner "shell" {
        inline = ["chmod u+x /home/${local.username}/ami/scripts/rpm/cleanup.sh", "sudo bash /home/${local.username}/ami/scripts/rpm/cleanup.sh"]
    }
    provisioner "shell" {
        inline = ["rm -rf /home/${local.username}/*"]
    }
    provisioner "shell-local" {
        inline = ["mv ./packerlog.txt ../logs/${var.date}/${local.distribution}/packerlog.txt"]
    }
}