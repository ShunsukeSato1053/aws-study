# provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

# moduleの利用
module "my_vpc" {
  # moduleの位置
  source = "../modules"

  # 変数へ値の設定
  my_cidr_block = "10.0.0.0/16"
  my_env        = "prod"
}
