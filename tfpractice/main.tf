# provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

# moduleの利用
module "my_vpc" {
  # moduleの位置
  source        = "./modules"
  my_cidr_block = var.my_cidr_block # ← 既にある場合はそのまま
  allowedCIDRs  = var.allowedCIDRs  # 自身の端末からのアクセスのみ許可
}
