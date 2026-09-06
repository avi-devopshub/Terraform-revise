resource "aws_key_pair" "my_key"{
    key_name = "my_key"
    public_key = file("/root/.ssh/id_ed25519.pub")
}

resource "aws_instance" "ec2"{
    ami = "ami-0199ac7c9fbf9ed83"
    instance_type = "t3.micro"
    key_name = aws_key_pair.my_key.key_name
    user_data = filebase64("/root/Terraform-revise/user-data/user_data.sh")
    tags = {
        Name = "tf-instance"
    }
}