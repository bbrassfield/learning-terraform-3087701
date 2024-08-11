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
              groupadd -g 40034 informatica
              useradd -u 40034 -g informatica informatica
              cp -rp /etc/skel /home/informatica
              chown -R informatica.informatica /home/informatica
              mkdir /mnt/informatica
              chown informatica.informatica /mnt/informatica
              chmod 755 /mnt/informatica
              apt install -y gnupg-agent
              echo "jenkins ALL=(informatica) NOPASSWD: /usr/bin/rsync" > /etc/sudoers.d/11_jenkins
              chmod 440 /etc/sudoers.d/11_jenkins
              echo "ENG_USERS   ALL=(root) /usr/local/sbin/encrypt.sh" > /etc/sudoers.d/51_engineering_passwd_encryptor
              chmod 440 /etc/sudoers.d/51_engineering_passwd_encryptor
              echo "DIST_USERS   ALL=(root) NOPASSWD: /usr/local/sbin/install_vault_token.sh" > /etc/sudoers.d/71_jenkins_install_vault_token
              chmod 440 /etc/sudoers.d/71_jenkins_install_vault_token
              mkdir /root/tokens
              chmod 700 /root/tokens
              touch /usr/local/sbin/install_vault_token.sh
              chmod 700 /usr/local/sbin/install_vault_token.sh
              touch /root/java_secure_file
              chmod 600 /root/java_secure_file
              touch /usr/local/sbin/jayspt-encryptor.jar
              chmod 644 /usr/local/sbin/jayspt-encryptor.jar
              touch /usr/local/sbin/encrypt.sh
              chmod 755 /usr/local/sbin/encrypt.sh
              touch /etc/rsyslog.d/20-whisker.conf
              chmod 755 /etc/rsyslog.d/20-whisker.conf
              touch /var/log/whisker.log
              chown syslog.adm /var/log/whisker.log
              chmod 644 /var/log/whisker.log
              apt install -y rssh
              mkdir /mnt/informatica/data
              chown informatica.informatica /mnt/informatica/data
              chmod 755 /mnt/informatica/data
              mkdir /mnt/informatica/sftp
              chown informatica.informatica /mnt/informatica/sftp
              chmod 755 /mnt/informatica/sftp
              touch /root/done_running_user_data_script
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