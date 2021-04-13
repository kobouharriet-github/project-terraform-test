provider "aws" {
  profile = "MyAWS"
  region = "us-east-1"
}


resource "aws_vpc" "my-vpc" {

cidr_block = "10.0.0.0/16"

    tags = {
    Name = "my-vpc"
    }
}

resource "aws_subnet" "my-subnet-public" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1"

  tags = {
    Name = "my-subnet-public"
  }
}