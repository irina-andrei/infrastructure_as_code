# Who is the provider
provider "aws" {

# Location of AWS
  region = var.aws-region #"eu-west-1"

}

# To download required dependencies

# Create a service/resource on the cloud - EC2 on AWS

resource "aws_instance" "irina-iac-test" {
  ami = var.web-app_ami_id #"ami-0943382e114f188e8"
  instance_type = "t2.micro"
  tags = {
	Name = "tech254-irina-iac-tf-test"
	}

}
