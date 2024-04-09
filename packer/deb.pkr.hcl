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
variable "SourceAMIName" {
  type    = string
  default = "debian-12-amd64-*-1532"
}
variable "SourceAMIOwner" {
  type    = string
  default = "136693071363"
}
locals {
  username = "admin"
  distribution = "debian"
  version = "12"
  date = "09-04-2024"
}

source "amazon-ebs" "main" {
  profile = "eurus-control"
  assume_role {
    role_arn = "arn:aws:iam::059516066038:role/central-managed-AdministratorAccess"
  }
  region = "us-east-2"
  ami_name = "ltscale-${local.distribution}${local.version}-${local.date}"
  source_ami_filter {
    filters = {
        name = "${var.SourceAMIName}"
        virtualization-type = "hvm"
        root-device-type = "ebs"
        }
        owners = ["${var.SourceAMIOwner}"]
        most_recent = true
  }

  instance_type = "t2.micro"
  ssh_username = "${local.username}"
  vpc_id = "vpc-038428d5c25e95813"
  subnet_id = "subnet-07c042f521955cb1e"
  associate_public_ip_address = true
  ssh_interface = "public_ip"
  security_group_ids = ["sg-002f0ddc6172d0ce1"]

  launch_block_device_mappings {
        device_name = "/dev/sdb"
        volume_size = 25
        volume_type = "gp2"
        delete_on_termination = false
        virtual_name = ""
        }

  tags = {
        Name = "ltscale-${local.distribution}-${local.version}-${local.date}"
        Permission = "Allowed"
        Source_AMI = "${var.SourceAMIName}"
        }
  run_tags = {
        OS = "debian"
        }
}
build {
    sources = ["source.amazon-ebs.main"]
    provisioner "file" {
        source = "/home/vagrant/public"
        destination = "/home/admin/"
    }
    // provisioner "shell" {
    //     inline = ["git clone -b jenkins https://github.com/scaleops/ami-hardening.git"]
    // }
    provisioner "shell" {
        inline = ["cloud-init status --wait", "sudo lsblk", "sudo apt update", "sudo apt-get update"]
    }
    provisioner "shell" {
        inline = ["chmod u+x /home/${local.username}/public/scripts/deb/ansible.sh", "sudo bash /home/${local.username}/public/scripts/deb/ansible.sh"]
    }
    provisioner "ansible-local" {
        playbook_file = "/home/${local.username}/public/ansible/deb-playbook.yml"
        extra_arguments = [
        "--inventory-file=/home/vagrant//ansible/inventory/aws_ec2.yml"
      ]
    }
    provisioner "shell" {
        inline = ["chmod u+x /home/${local.username}/public/scripts/deb/cleanup.sh", "sudo bash /home/${local.username}/public/scripts/deb/cleanup.sh"]
    }
}