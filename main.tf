data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "billtest" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.billtest.id]

  key_name = "bbrassfield_learning-terraform"

  tags = {
    Name = "Bills Terraform Test VM"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y joe parted zfs-fuse command-not-found
              apt update
              EOF
}

resource "aws_security_group" "billtest" {
  name        = "billtest"
  description = "Allow https and https in, Allow everything out"

  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "billtest_http_in" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.billtest.id
}

resource "aws_security_group_rule" "billtest_https_in" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.billtest.id
}

resource "aws_security_group_rule" "billtest_ssh_in" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.billtest.id
}

resource "aws_security_group_rule" "billtest_everything_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.billtest.id
}

resource "aws_ebs_volume" "billtestvol1" {
  availability_zone = aws_instance.billtest.availability_zone
  size              = 100

  tags = {
    Name = "billtest-volume-1"
  }
}

resource "aws_volume_attachment" "billtest" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.billtestvol1.id
  instance_id = aws_instance.billtest.id
}