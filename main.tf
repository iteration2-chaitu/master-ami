resource "aws_instance" "ami" {
  ami           = data.aws_ami.ami.image_id
  instance_type = "t3.small"
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = "ami-server"

  }
}

resource "null_resource" "ansible" {

  connection {
    type     = "ssh"
    //user     = var.ssh_user   #"ec2-user"
    user     = jsondecode(data.vault_generic_secret.ssh.data_json).ansible_user
    //password = var.ssh_password   #"DevOps321"
    password = jsondecode(data.vault_generic_secret.ssh.data_json).ansible_password
    #      host     = aws_instance.instance.public_ip
    host     = aws_instance.ami.private_ip   #this is once we create nat gateways
  }


  provisioner "remote-exec" {

    inline = [

      "sudo pip3.11 install ansible hvac"


    ]
  }

}

resource "aws_ami_from_instance" "ami" {
  depends_on = [null_resource.ansible]
  name               = "golden-ami ${formatdate("DD-MM-YY",timestamp())}"
  source_instance_id = aws_instance.ami.id

  lifecycle {
    ignore_changes = [
      name
      ##only for one Images in a day,if we need second AMI code needs to be chnaged
    ]
  }
}