#VPC Create
resource "aws_vpc" "dev_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "dev-vpc"
    }
}
#Public Subnet create
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = "10.0.0.0/20"
    availability_zone = "ap-south-2a"
    map_public_ip_on_launch = true
    tags = {
        Name = "public_subnet"
    }
}
#Private subnet create
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = "10.0.16.0/20"
    availability_zone = "ap-south-2b"
    map_public_ip_on_launch = false
    tags = {
        Name = "private_subnet"
    }
}
#Internet Gateway create
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.dev_vpc.id
    tags = {
        Name = "igw"
    }
}
#EIP create
resource "aws_eip" "eip" {
    domain = "vpc"
    tags = {
        Name = "eip"
    }
}
#Nat gateway create
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.public_subnet.id
    tags = {
        Name = "nat"
    }
}
#Public rt
resource "aws_route_table" "public_rt"{
    vpc_id = aws_vpc.dev_vpc.id
    route{
        gateway_id = aws_internet_gateway.igw.id
        cidr_block = "0.0.0.0/0"
    }
    tags = {
        Name = "public_rt"
    }
}
#Public rt association
resource "aws_route_table_association" "public_rt_association" {
    route_id = aws_route_table.public_rt.id
    subnet_id = aws_subnet.public_subnet.id
}
#Private rt
resource "aws_route_table" "private_rt"{
    vpc_id = aws_vpc.dev_vpc.id
    route{
        nat_gateway_id = aws_nat_gateway.nat.id
        cidr_block = "0.0.0.0/0"
    }
    tags = {
        Name = "private_rt"
    }
}
#Private rt association
resource "aws_route_table_association" "private_rt_association" {
    route_id = aws_route_table.private_rt.id
    subnet_id = aws_subnet.private_subnet.id
}
#Security Group craete
resource "aws_security_group" "sg" {
    vpc_id = aws_vpc.dev_vpc.id
    name = "sg"
    description = "sg"
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
     ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}