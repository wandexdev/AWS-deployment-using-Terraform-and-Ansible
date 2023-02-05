terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket         = var.S3_bucket_name
    key            = var.bucket_key
    region         = 
  }
}
