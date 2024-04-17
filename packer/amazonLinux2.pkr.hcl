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
variable "distribution" {
  type    = string
  default = env("DISTRIBUTION")
}
variable "username" {
  type    = string
  default = env("USERNAME")
}

  default = "amzn2-ami-kernel-5.10-hvm-2.0.*.0-x86_64-gp2"


  default = "137112412989" 

###########################################################

source "amazon-ebs" "main" {
  profile = "eurus-control"
  assume_role {
    role_arn = "arn:aws:iam::059516066038:role/central-managed-AdministratorAccess"
  }
  region = "us-east-2"
  ami_name = "scaleops-${var.distribution}-${var.date}"
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
  ssh_username = "${var.username}"
  vpc_id = "vpc-038428d5c25e95813"
  subnet_id = "subnet-07c042f521955cb1e"
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
        Name = "scaleops-${var.distribution}-${var.date}"
        Permission = "Allowed"
        Source_AMI = "${var.SourceAMIName}"
        }
}
###########################################################


build {
    sources = ["source.amazon-ebs.main"]
    provisioner "shell-local" {
        inline = ["mkdir -p ${var.dir}/logs/${var.date}/${var.distribution}", "PACKER_LOG=1"]
    }
    provisioner "file" {
        source = "${var.dir}"
        destination = "/home/${var.username}/ami"
    }
    provisioner "shell" {
        inline = ["sudo lsblk"]
    }
    provisioner "shell" {
        inline = ["chmod u+x /home/${var.username}/ami/scripts/rpm/${var.distribution}.sh", "sudo bash /home/${var.username}/ami/scripts/rpm/${var.distribution}.sh"]
    }
    provisioner "shell" {
        inline = ["mkdir -p ~/.ansible/roles", "cp -r ~/ami/ansible/roles/* ~/.ansible/roles/"]
    }
    provisioner "ansible-local" {
        playbook_file = "../ansible/rpm-playbook.yml"
    }
    provisioner "shell" {
        inline = ["chmod u+x /home/${var.username}/ami/scripts/rpm/cleanup.sh", "sudo bash /home/${var.username}/ami/scripts/rpm/cleanup.sh"]
    }
    provisioner "shell" {
        inline = ["rm -rf /home/${var.username}/*"]
    }
    provisioner "shell-local" {
        inline = ["mv ./packerlog.txt ../logs/${var.date}/${var.distribution}/packerlog.txt"]
    }
}