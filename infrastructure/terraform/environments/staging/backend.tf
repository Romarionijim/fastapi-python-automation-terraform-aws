terraform {
  backend "s3" {
    bucket         = "tf-state-arn-01"
    key            = "tf-state-arn-01/staging/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "dynamodb_state_lock_table_romario"
    encrypt        = true
  }
}
