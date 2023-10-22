# Who is the provider
provider "aws" {

# Location of AWS
  region = var.aws-region 

}

# To download required dependencies
# Create a service/resource on the cloud - EC2 on AWS


# Creating a VPC
resource "aws_vpc" "tech254-irina-terraform-vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
	Name = "tech254-irina-terraform-vpc"
	}

}

# Creating a Public Subnet:
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.tech254-irina-terraform-vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-west-1a"
    tags = {
        Name = "public_subnet"
    }
}

# Creating a Private Subnet:
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.tech254-irina-terraform-vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "eu-west-1b"
    tags = {
        Name = "private_subnet"
    }
}

# Creating Internet Gateway:
resource "aws_internet_gateway" "tech254-irina-terraform-vpc-ig" {
    vpc_id = aws_vpc.tech254-irina-terraform-vpc.id
    tags = {
        Name = "tech254-irina-terraform-vpc-ig"
    }
}

# Create Route Table:
resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.tech254-irina-terraform-vpc.id
    tags = {
        Name = "public-rt"
    }
    # Create route from route table to Internet gateway (target)
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.tech254-irina-terraform-vpc-ig.id
    }
}

# Associate Route Table to Public Subnet:
resource "aws_route_table_association" "public_subnet" {
    route_table_id = aws_route_table.public-rt.id
    subnet_id = aws_subnet.public_subnet.id
}

# Associate Internet Gateway:
resource "aws_route" "public_subnet_igw_route" {
    route_table_id = aws_route_table.public-rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tech254-irina-terraform-vpc-ig.id
}


# Define the security group for the application instance
resource "aws_security_group" "sg_for_app" {
  name_prefix = "sg_for_app"
  description = "Security group for the app instance"
  vpc_id = aws_vpc.tech254-irina-terraform-vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
    # Allow incoming HTTP traffic from anywhere
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    # Allow incoming SSH traffic from anywhere
  }

    ingress {
    description      = "Nodejs"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    # Allow incoming SSH traffic from anywhere
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "tech254-irina-iac-terraform" {
  ami = var.web-app_ami_id 
  instance_type = "t2.micro"
  tags = {
	Name = "tech254-irina-iac-terraform"
	}

}