# ----------
# 変数定義
# ----------
# ciderblock(自身の端末からのアクセスのみ許可)
variable "allowedCIDRs" {
  type        = string
  description = "KeyPairの設定用変数"
  default     = "129.227.238.198/32"
}

# ----------
# リソース定義
# ----------
# セキュリティグループの作成（EC2用）
# Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "tf_testec2_sg"
  description = "ec2 security group"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "tf_ec2_sg"
  }
}

# セキュリティグループの作成（RDS用）
resource "aws_security_group" "rds_sg" {
  name        = "tf_rds_sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id] # EC2からの接続を許可
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "tf_rds_sg"
  }
}

# セキュリティグループの作成（ALB用）
resource "aws_security_group" "alb_sg" {
  name        = "awsstudy-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf_alb_sg"
  }
}
