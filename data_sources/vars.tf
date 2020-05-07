variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-13be557e"
    us-east-2 = "ami-0c55b159cbfafe1f0"
    # eu-west-1 = "ami-844e0bf7"
  }
}

