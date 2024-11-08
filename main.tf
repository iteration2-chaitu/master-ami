resource "aws_instance" "ami" {
  ami           = data.aws_ami.ami.image_id
  instance_type = "t3.small"
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = "ami-server"

  }
}