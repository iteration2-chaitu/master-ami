terraform {
  backend "s3" {

    bucket = "tf-mybucketchai"
    key    = "ami/state"
    region = "us-east-1"

  }
}