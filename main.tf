provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ami.id
  instance_type = "t3.micro"

 #thuộc tính giúp zero downtime
  lifecycle {
    create_before_destroy = true  #zero downtime
  }
 #nên cân nhắc khi dùng create_before_destroy, trong trường hợp EC2 thì có thể, tuy nhiên các resource như S3 (tên bucket phải duy nhất) thì không được dùng create_before_destroy
  tags = {
    Name = "Server"
  }
}

output "public_ip" {
  value = aws_instance.server.public_ip
}
