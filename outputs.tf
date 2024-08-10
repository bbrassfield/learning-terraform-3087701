output "instance_ami" {
  value = aws_instance.billtest.ami
}

output "instance_arn" {
  value = aws_instance.billtest.arn
}

output "instance_public_ip" {
  value = aws_instance.billtest.public_ip
}
