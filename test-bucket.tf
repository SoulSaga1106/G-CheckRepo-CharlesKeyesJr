terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use latest version if possible
    }
  }

  backend "s3" {
    bucket  = "the-36th-chamber-s3-gcheck"  # Name of the S3 bucket
    key     = "jenkins-test-000036.tfstate" # The name of the state file in the bucket
    region  = "us-east-2"                   # Use a variable for the region
    encrypt = true                          # Enable server-side encryption (optional but recommended)
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "wutang-bucket" {
  bucket_prefix = "wutang-bucket-"
  force_destroy = true


  tags = {
    Name = "wutang-bucket"
  }
}

