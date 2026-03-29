terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "the-36th-chamber-s3-gcheck"
    key     = "jenkins-test-000036.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "wutang" {
  bucket_prefix = "wutang-"
  force_destroy = true

  tags = {
    Name = "wutang"
  }
}

resource "aws_s3_object" "pipeline_success" {
  bucket       = aws_s3_bucket.wutang.bucket
  key          = "pipeline_success.png"
  source       = "${path.module}/proof/pipeline_success.png"
  content_type = "image/png"
  etag         = filemd5("${path.module}/proof/pipeline_success.png")
}

resource "aws_s3_object" "webhook" {
  bucket       = aws_s3_bucket.wutang.bucket
  key          = "webhook.png"
  source       = "${path.module}/proof/webhook.png"
  content_type = "image/png"
  etag         = filemd5("${path.module}/proof/webhook.png")
}

resource "aws_s3_object" "webhook_bash_trigger" {
  bucket       = aws_s3_bucket.wutang.bucket
  key          = "webhook-bash-trigger.png"
  source       = "${path.module}/proof/webhook-bash-trigger.png"
  content_type = "image/png"
  etag         = filemd5("${path.module}/proof/webhook-bash-trigger.png")
}

resource "aws_s3_object" "s3_bucket_pic" {
  bucket       = aws_s3_bucket.wutang.bucket
  key          = "s3_bucket_pic.png"
  source       = "${path.module}/proof/s3_bucket_pic.png"
  content_type = "image/png"
  etag         = filemd5("${path.module}/proof/s3_bucket_pic.png")
}

resource "aws_s3_object" "armageddon_proof" {
  bucket       = aws_s3_bucket.wutang.bucket
  key          = "Armageddon-proof.md"
  source       = "${path.module}/proof/Armageddon-proof.md"
  content_type = "text/markdown"
  etag         = filemd5("${path.module}/proof/Armageddon-proof.md")
}

resource "aws_s3_bucket_public_access_block" "wutang" {
  bucket = aws_s3_bucket.wutang.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "wucheck" {
  bucket = aws_s3_bucket.wutang.id

  depends_on = [
    aws_s3_bucket_public_access_block.wutang
  ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadObjects"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.wutang.arn}/*"
      }
    ]
  })
}