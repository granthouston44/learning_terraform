provider "aws" {
    region = "us-east-2"
}

# define variables to ensure code is dry
# use variables in a .tfvars to keep aws credentials secure (add to .gitignore)
# use variables to store things that might change - i.e. different amis per region
# this code uses an environment variable so set the port number, ensuring we dont repeat it in user data and security settings

variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type        = number
    default = 8080
}

# "${...}" string interpolation syntax
resource "aws_instance" "example" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]
    
    user_data = <<-EOF
              #!/bin/bash
              echo "aww hullo there!" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
    
    tags = {
        Name = "terraform-example"
    }
}

resource "aws_launch_configuration" "example" {
image_id            = "ami-0c55b159cbfafe1f0"
instance_type       = "t2.micro"
security_groups     = [aws_security_group.instance.id]
}

resource "aws_security_group" "instance"{
    name = "terraform-example-instance"

    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


# will print out at the end of the 'terraform apply' command 
# useful to know what ip we are working with 
# can also just use 'terraform output' command to see the output without applying changes 
# the output command can be extended by appending the name of the output variable
# 'terraform output public_ip'
output "public_ip" {
    value           = aws_instance.example.public_ip
    description = "The public IP of the web server!"
}