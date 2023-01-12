

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    rundeck = {
      source = "rundeck/rundeck"
    }
    aws = {
      source = "hasicorp/aws"
    }
  }
}