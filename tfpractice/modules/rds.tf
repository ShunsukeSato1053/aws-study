# ----------
# 変数定義
# ----------

# ----------
# リソース定義
# ----------
# DBサブネットグループの作成
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "awsstudy-db-subnet-group"
  subnet_ids = [aws_subnet.test_privatesubnet_1a.id, aws_subnet.test_privatesubnet_1c.id]
  tags = {
    Name = "awsstudy-db-subnet-group"
  }
}

# RDS作成時のパスワードをSSM パラメータストアから取得
data "aws_ssm_parameter" "db_password" {
  name            = "/rds/masteruserpassword"
  with_decryption = true
}

# RDSの作成
resource "aws_db_instance" "rds" {
  identifier             = "tf-rds"
  engine                 = "mysql"
  engine_version         = "8.0.39"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = "root"
  password               = data.aws_ssm_parameter.db_password.value
  db_name                = "awsstudy"
  multi_az               = false
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  enabled_cloudwatch_logs_exports = [
    "audit",
    "error",
    "general",
    "slowquery"
  ]
  skip_final_snapshot = true
  tags = {
    Name = "awsstudy-rds"
  }
  depends_on = [
    aws_db_subnet_group.rds_subnet_group
  ]
}

