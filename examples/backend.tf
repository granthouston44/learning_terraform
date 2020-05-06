# you can store state remotely using a backend.tf file like this. It means that the state is available for everyone to work with. 
# You need to run terraform init for the remote state to be uploaded 

# note: the s3 bucket must be setup prior

# need to setup aws credentials for the aws CLI
# can see stored credentials useing ~/.aws/credentials
terraform {
    backend "s3" {
        bucket = "terraform-state-sefegw"
        key = "terraform/examples"
        region = "us-east-2"
    }
}