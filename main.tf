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