# ----------
# 変数定義
# ----------
# cidrblock
variable "my_cidr_block" {
  default = "10.0.0.0/16"
}

# ----------
# リソース定義
# ----------
# VPCの作成
resource "aws_vpc" "test_vpc" {
  cidr_block           = var.my_cidr_block # v0.12以降の書き方
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf-vpc" # 文字列内に変数を埋め込む場合はこの書き方（v0.11形式）
  }
}

# IGWの作成、接続設定
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name = "tf_igw"
  }
}

# パブリックルートテーブルとIGWの関連付け
resource "aws_route" "rtb_igw_route" {
  route_table_id         = aws_route_table.test_publicrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.test_igw.id
}

# パブリックサブネット1aの作成
resource "aws_subnet" "test_publicsubnet_1a" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "tf_test_public1a"
  }
}

# パブリックサブネット1cの作成
resource "aws_subnet" "test_publicsubnet_1c" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.0.16.0/20"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "tf_test_public1c"
  }
}

# プライベートサブネット1aの作成
resource "aws_subnet" "test_privatesubnet_1a" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.0.128.0/20"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "tf_test_private1a"
  }
}

# プライベートサブネット1cの作成
resource "aws_subnet" "test_privatesubnet_1c" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.0.144.0/20"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "tf_test_private1c"
  }
}

# パブリックルートテーブルの作成、ルート設定
resource "aws_route_table" "test_publicrt" {
  vpc_id = aws_vpc.test_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }
  tags = {
    Name = "tf_publicrt"
  }
}

# パブリックサブネット1aをルートテーブルに関連付け
resource "aws_route_table_association" "test_publicrt_associate1a" {
  subnet_id      = aws_subnet.test_publicsubnet_1a.id
  route_table_id = aws_route_table.test_publicrt.id
}

# パブリックサブネット1cをルートテーブルに関連付け
resource "aws_route_table_association" "test_publicrt_associate1c" {
  subnet_id      = aws_subnet.test_publicsubnet_1c.id
  route_table_id = aws_route_table.test_publicrt.id
}

# プライベートルートテーブル1aの作成
resource "aws_route_table" "test_privatert1a" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name = "tf_privatert1a"
  }
}

# プライベートサブネット1aをルートテーブルに関連付け
resource "aws_route_table_association" "test_privatert_associate1a" {
  subnet_id      = aws_subnet.test_privatesubnet_1a.id
  route_table_id = aws_route_table.test_privatert1a.id
}

# プライベートルートテーブル1cの作成
resource "aws_route_table" "test_privatert1c" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name = "tf_privatert1c"
  }
}

# プライバシーサブネット1cをルートテーブルに関連付け
resource "aws_route_table_association" "test_privatert_associate1c" {
  subnet_id      = aws_subnet.test_privatesubnet_1c.id
  route_table_id = aws_route_table.test_privatert1c.id
}

# vpcエンドポイントの作成（ゲートウェイ型）
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.test_vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"
  # プライベートルートテーブルの指定
  route_table_ids = [
    aws_route_table.test_privatert1a.id,
    aws_route_table.test_privatert1c.id
  ]
  tags = {
    Name = "tf_s3"
  }
}

