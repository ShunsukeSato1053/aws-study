terraform {
  backend "s3" {
    bucket         = "shunsuke-terraform-tfstate-bucket-2025.07.31" # 作成したS3バケット名
    key            = "terraform.tfstate"                            # S3内のパス
    region         = "ap-northeast-1"
    dynamodb_table = "shunsuke-terraform-tfstate-lock-table" # 作成したDynamoDBテーブル名
    encrypt        = true
  }
}

