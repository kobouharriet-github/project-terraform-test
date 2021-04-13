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

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public.*.id

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_s3_bucket" "lb" {
  bucket = "my-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}