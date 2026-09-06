resource "aws_instance" "ec2"{
    ami = "ami-0199ac7c9fbf9ed83"
    instance_type = "t3.micro"
    key_name = "hyderabad"
    tags = {
        Name = "tf-instance"
    }
}