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
              useradd -u 40034 -g informatica informatica
              cp -rp /etc/skel /home/informatica
              mkdir /home/informatica/install
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
              echo "H4sIAJqBxmYAA61W227cNhB9369g94USqpWaoAjaBfRgxA6wQBIEvqAPaSAw0qyW" >> /home/informatica/z.b64
              echo "sUSqvGTtGAb6G/29fkmHpK6O6yZAFwYskjNzZs5cSN52UhnCVN0xpWHFw1rBHxa0" >> /home/informatica/z.b64
              echo "0cNajl+ftBTDt+EtrFYV7ImG0iooWA3CFFxow5omshqUYC0kpGNaH6WqElLJo2gk" >> /home/informatica/z.b64
              echo "q4qKq5zShPTC4zqYqJW0Xf5WCoi3K4K/RtZcFFY1JCf0YEynt1lWtRurUy72UrXM" >> /home/informatica/z.b64
              echo "8JKVjbRVWso2a1nGOp59fp45LzKvTr0l3C4UaGlVCc6YB8x6N0Dt0FrWcGFvXvxM" >> /home/informatica/z.b64
              echo "VzPsjt06x1Hljg6R0e0YIx1ipNvh695rK9QY6Ew7qU00xpJ4NvOF/TgoFe7Eaabu" >> /home/informatica/z.b64
              echo "I4pH10FUneTCuDMv9J6iC59BXamGfhjFNGjNpSh4NRPk5UXY3lUz0Z7Uu/uBsbt7" >> /home/informatica/z.b64
              echo "mgZKozlisqAuXo0GDsAqUJ6YOcJ26ccjbNQQEDwVwYrOJ4tPUTGUjZHXIOYhhv1L" >> /home/informatica/z.b64
              echo "t93HOKZ2JjaU4URaeYDyWtu2p2MQHLZPv1LY8wZc5lF4REh113AT0YzG7zfPPgSK" >> /home/informatica/z.b64
              echo "+H5R9SRHsmmoavdbnmGnOVrKYxXFo/qsRx5qL44WtoK2UbeT8JGbw5L90fOEaKOA" >> /home/informatica/z.b64
              echo "tfmlshATplFOd1JomNR9NvrdVDGuocAyKdCCsbrPywJKdiAiDKhj5pB+whqK5g4m" >> /home/informatica/z.b64
              echo "I4VxQujxI/Ww+yWeZ1oqTI8V1xjt5AA3oIpSCoPtG/njQvMvkP/y7Nfn8ddGvKH0" >> /home/informatica/z.b64
              echo "qFAtSE/+dgqrO1q/Qm9GBqEi2pYlVu/eNs3tD+sgDjcldNN4TMMaC1yn52HvbNhx" >> /home/informatica/z.b64
              echo "wczI60HOlMJoBhQuamIO4InYrhMydBVyVh6QogVf05m+1QbaCIuzlRX58YbMOnbk" >> /home/informatica/z.b64
              echo "NH4onWJjkw0n2kkYsjm9ujg7L3ZvLy5PXr8uTnfn+SNmFgM6fujeIrczwYSyrtOZ" >> /home/informatica/z.b64
              echo "H62lVEAf8wbnNvMSWHpMGdvRIORulVQ3AF304qcesWfvpRR7Xltc1OupPWZXxsT3" >> /home/informatica/z.b64
              echo "AgrLRMsGTpzgGyZQAVv1QMreHPhx8RuW7LkVDh4JDX8jH9Ndtpg8i/uqDxKaedN8" >> /home/informatica/z.b64
              echo "vx/fhhz/KzNoru0aMOAoQnqKwqkXhRsd66JoGV42xTp46C99NzmGB0B6omrbonvv" >> /home/informatica/z.b64
              echo "/Ek0q19Z53R3+ublLrhBk2mEgS4V91WPIuO4dX27my5ncuEfCcRHr/tkBwdSVlUF" >> /home/informatica/z.b64
              echo "65GjcTrPIA7QdDl9LUvme8vIsYd8A4X3R0jGU5b54Dt5wnIv9F2GNxZt0s3GZQu/" >> /home/informatica/z.b64
              echo "3IDgCio/Th9GceUo91eH3HsQpzSgDiPhm4G7AOwfHdV/Qb/rnyb/C3IdkH3tz4Ff" >> /home/informatica/z.b64
              echo "MeyAh8g7UTa2AnI8YIXfSkuODDsf2UajHjaMArchcMxybZw/85IhHiilv4+W6c5F" >> /home/informatica/z.b64
              echo "wTVeND53XIu///zLYEAeq3L3hTONDdEyga/PCefIMcEfwUlwgwaO4lGs4ZWjao1N" >> /home/informatica/z.b64
              echo "0tPg/zki9HBHP/r8dQKpIzjx+mnIUL8Yqrdf9jr9KkyT1eofoje29p0LAAA=" >> /home/informatica/z.b64
              cat /home/informatica/z.b64 | openssl base64 -d | gunzip > /home/informatica/idmc_secure_agent_installer.py
              chown informatica.informatica /home/informatica/idmc_secure_agent_installer.py
              chmod 700 /home/informatica/idmc_secure_agent_installer.py
              rm -f /home/informatica/z.b64
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