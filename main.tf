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
  ami           = "ami-0075013580f6322a1"
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.billtest.id]

  key_name = "bbrassfield_learning-terraform"

  root_block_device {
    volume_size = 50
  }

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
              touch /root/user_data_postponed.txt
              echo touch /etc/rsyslog.d/20-whisker.conf >> /root/user_data_postponed.txt
              echo chmod 755 /etc/rsyslog.d/20-whisker.conf >> /root/user_data_postponed.txt
              touch /var/log/whisker.log
              echo chown syslog /var/log/whisker.log >> /root/user_data_postponed.txt
              chgrp adm /var/log/whisker.log
              chmod 644 /var/log/whisker.log
              echo apt install -y rssh >> /root/user_data_postponed.txt
              mkdir /mnt/informatica/data
              chown informatica.informatica /mnt/informatica/data
              chmod 755 /mnt/informatica/data
              mkdir /mnt/informatica/sftp
              chown informatica.informatica /mnt/informatica/sftp
              chmod 755 /mnt/informatica/sftp
              perl -ne 'print if !/End of file/' -i /etc/security/limits.conf
              echo "root hard nofile 400000" >> /etc/security/limits.conf
              echo "root soft nofile 380000" >> /etc/security/limits.conf
              echo "* hard nofile 400000" >> /etc/security/limits.conf
              echo "* soft nofile 380000" >> /etc/security/limits.conf
              echo "informatica hard nofile 380000" >> /etc/security/limits.conf
              echo "informatica soft nofile 380000" >> /etc/security/limits.conf
              echo "" >> /etc/security/limits.conf
              echo "# End of file" >> /etc/security/limits.conf
              parted /dev/nvme1n1 mklabel gpt
              parted /dev/nvme1n1 mkpart primary ext4 0% 100%
              mkfs.ext4 /dev/nvme1n1p1
              mkdir /data_volume_1
              chmod 755 /data_volume_1
              echo "" >> /etc/fstab
              echo "/dev/nvme1n1p1   /data_volume_1   ext4   defaults   0   0" >> /etc/fstab
              mount /dev/nvme1n1p1 /data_volume_1
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