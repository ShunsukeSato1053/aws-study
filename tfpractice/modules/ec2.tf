# ----------
# 変数定義
# ----------

# ----------
# リソース定義
# ----------
# EC2作成時のキーペア名をSSM パラメータストアから取得
data "aws_ssm_parameter" "ec2_KeyName" {
  name            = "/ec2/keypair"
  with_decryption = true
}

# GitHubActions経由でAnsibleを動かすためにSSM接続設定
# 1. SSM用IAMロール作成
resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# 2. SSMポリシー付与
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# 3. インスタンスプロファイル作成
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

# EC2の作成
resource "aws_instance" "test_ec2" {
  ami                         = "ami-027fff96cc515f7bc"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.test_publicsubnet_1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = data.aws_ssm_parameter.ec2_KeyName.value
  # SSM接続用のIAMインスタンスプロファイルを設定
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "tf_ec2"
  }
}

# Git HubActions用にEC2を追加で作成
resource "aws_instance" "test_ec2_githubactions" {
  ami                         = "ami-027fff96cc515f7bc"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.test_publicsubnet_1c.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = data.aws_ssm_parameter.ec2_KeyName.value

  tags = {
    Name = "tf_ec2_githubactions"
  }
}


# ===== Output 定義 =====
# GitHub ActionsがSSM経由で接続
output "githubactions_ec2_instance_id" {
  description = "GitHub ActionsがSSM経由で接続するためのインスタンスID"
  value       = aws_instance.test_ec2.id
}
