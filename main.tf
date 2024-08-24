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
              apt install -y joe parted command-not-found
              apt update
              groupadd -g 40034 informatica
              useradd -u 40034 -g informatica -s /bin/bash -m -k /etc/skel informatica
              # cp -rp /etc/skel /home/informatica
              mkdir -p /home/informatica/install
              chmod 755 /home/informatica/install
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
              cat << 'SCRIPT' > /home/informatica/z.b64
              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
              QuV1n51M9+WIi8rLLY5G9dnkP4KRKtAJEAAA
              SCRIPT
              cat /home/informatica/z.b64 | openssl base64 -d | gunzip > /home/informatica/idmc_secure_agent_installer.py
              chown informatica.informatica /home/informatica/idmc_secure_agent_installer.py
              chmod 700 /home/informatica/idmc_secure_agent_installer.py
              rm -f /home/informatica/z.b64
              echo "python3 idmc_secure_agent_installer.py /home/informatica /home/informatica/install -u ${idmc_sa_installer_user} -p ${idmc_sa_installer_pass} -g ${idmc_sa_installer_group}" > /root/run_installer.txt
              # parted /dev/nvme1n1 mklabel gpt
              # parted /dev/nvme1n1 mkpart primary ext4 0% 100%
              # mkfs.ext4 /dev/nvme1n1p1
              # mkdir /data_volume_1
              # chmod 755 /data_volume_1
              # echo "" >> /etc/fstab
              # echo "/dev/nvme1n1p1   /data_volume_1   ext4   defaults   0   0" >> /etc/fstab
              # mount /dev/nvme1n1p1 /data_volume_1
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