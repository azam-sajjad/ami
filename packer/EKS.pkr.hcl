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
variable "source_ami_id" {
  type    = string
  default = env("AMI_ID")
}
variable "region" {
  type    = string
  default = env("AWS_DEFAULT_REGION")
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
  username = "ec2-user"
  distribution = "EKS"               
}
###########################################################

source "amazon-ebs" "main" {
  profile = "eurus-control"
  assume_role {
    role_arn = "arn:aws:iam::059516066038:role/central-managed-AdministratorAccess"
  }
  region = "${var.region}"
  ami_name = "scaleops-${local.distribution}-${var.date}"
  source_ami = "${var.source_ami_id}"
  instance_type = "t2.micro"
  ssh_username = "${local.username}"
  vpc_id = "vpc-038428d5c25e95813"
  subnet_id = "subnet-07c042f521955cb1e"
  associate_public_ip_address = true
  ssh_interface = "public_ip"
  security_group_ids = ["sg-002f0ddc6172d0ce1"]

  tags = {
        Name = "scaleops-${local.distribution}-${var.date}"
        Permission = "Allowed"
        }
}
###########################################################


build {
    sources = ["source.amazon-ebs.main"]
    provisioner "shell-local" {
        inline = ["mkdir -p ~/public/logs/${var.date}/${local.distribution}", "PACKER_LOG=1"]
    }
    provisioner "file" {
        source = "/home/vagrant/public"
        destination = "/home/${local.username}/"
    }
    provisioner "shell" {
        inline = ["sudo lsblk"]
    }
    provisioner "shell" {
        inline = ["chmod u+x /home/${local.username}/public/scripts/rpm/${local.distribution}.sh", "sudo bash /home/${local.username}/public/scripts/rpm/${local.distribution}.sh"]
    }
    provisioner "shell" {
        inline = ["mkdir -p ~/.ansible/roles", "cp -r ~/public/ansible/roles/* ~/.ansible/roles/"]
    }
    provisioner "ansible-local" {
        playbook_file = "../ansible/ecs-playbook.yml"
    }
    provisioner "shell" {
        inline = ["chmod u+x /home/${local.username}/public/scripts/rpm/cleanup.sh", "sudo bash /home/${local.username}/public/scripts/rpm/cleanup.sh"]
    }
    provisioner "shell" {
        inline = ["rm -rf /home/${local.username}/*"]
    }
    provisioner "shell-local" {
        inline = ["mv ./packerlog.txt ../logs/${var.date}/${local.distribution}/packerlog.txt"]
    }
}