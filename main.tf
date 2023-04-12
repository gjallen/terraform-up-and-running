provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webtraffic.id]
  # '.id' is an exported attribute of the aws_security_group
  # resource. We could use an argument from that resource 
  # instead if we wanted, e.g. '.name'
   

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  
  user_data_replace_on_change = true
  
  tags = {
    Name = "guy-terraform-example"
  }
}

resource "aws_security_group" "webtraffic" {
  name = "terraform-example-instance"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }
}
