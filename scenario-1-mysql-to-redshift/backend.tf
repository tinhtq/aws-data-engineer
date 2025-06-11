terraform {
  backend "s3" {
    bucket  = "276084501312-tf-state"
    key     = "dms-scenarios/scenario-1-mysql-to-redshift/terraform.tfstate"
    region  = "ap-southeast-1"
    encrypt = true
  }
}
