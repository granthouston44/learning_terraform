# data being pulled from AWS that contains all the IP ranges 
# it is being filtered with the regions and services
data "aws_ip_ranges" "us_ec2" {
  regions  = ["us-east-1", "us-east-2"]
  services = ["ec2"]
}

# referring to our data above
# using the slice option to get around the maximum number of rules per security group error
resource "aws_security_group" "from_us" {
  name = "from_us"

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = slice(data.aws_ip_ranges.us_ec2.cidr_blocks, 0 ,20)
  }
  tags = {
    CreateDate = data.aws_ip_ranges.us_ec2.create_date
    SyncToken  = data.aws_ip_ranges.us_ec2.sync_token
  }
}

