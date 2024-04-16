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
variable "SourceAMIName" {
  type    = string
  default = "amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"
}
variable "SourceAMIOwner" {
  type    = string
  default = "591542846629"
}
locals {
  linux_flavor = "rpm"          # "deb" -or- "rpm"
  username = "ec2-user"
  // run_tag = "al2"               # for Ansible Inventory
  distribution = "amazonLinux"  # for AMI naming
  version = "2"                 # for AMI naming
  date = "15-04-2024"           # for AMI naming
}
###########################################################

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
  ami_block_device_mappings = {
        device_name = "/dev/xvda"
        volume_size = 8
        delete_on_termination = true
        }
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
  // run_tags = {
  //       OS = "${var.run_tag}"
  //       }
}
###########################################################


build {
    sources = ["source.amazon-ebs.main"]
    provisioner "shell-local" {
        inline = ["mkdir -p ~/public/logs/${local.date}/${local.distribution}-${local.version}"]
    }
    provisioner "shell-local" {
        inline = ["PACKER_LOG=1", "PACKER_LOG_PATH=~/public/logs/${local.date}/${local.distribution}-${local.version}/packerlog.txt"]
    }
    provisioner "file" {
        source = "/home/vagrant/public"
        destination = "/home/${local.username}/"
    }
    provisioner "shell" {
        inline = ["cloud-init status --wait", "sudo lsblk", "sudo apt update", "sudo apt-get update"]
    }
    provisioner "shell" {
        inline = ["chmod u+x /home/${local.username}/public/scripts/deb/ansible.sh", "sudo bash /home/${local.username}/public/scripts/deb/ansible.sh"]
    }
    provisioner "shell" {
        inline = ["mkdir -p ~/.ansible/roles", "cp -r ~/public/ansible/roles/* ~/.ansible/roles/"]
    }
    provisioner "ansible-local" {
        playbook_file = "../ansible/deb-playbook.yml"
    }
    provisioner "shell" {
        inline = ["lynis audit system --pentest | tee -a ~/lynis.report"]
    }
    provisioner "file" {
        source = "~/lynis.report"
        destination = "../logs/${local.date}/${local.distribution}-${local.version}/lynis.report"
        direction = "download"
    }
    provisioner "shell" {
        inline = ["chmod u+x /home/${local.username}/public/scripts/deb/cleanup.sh", "sudo bash /home/${local.username}/public/scripts/deb/cleanup.sh"]
    }
    provisioner "shell" {
        inline = ["rm -rf /home/${local.username}/*"]
    }
}