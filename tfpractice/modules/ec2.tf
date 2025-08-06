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


# ----------
# Output 定義
# ----------

# GitHub ActionsがSSH経由で接続するためのパブリックIP
output "githubactions_ec2_public_ip" {
  description = "GitHub ActionsがSSH経由で接続するためのEC2パブリックIP"
  value       = aws_instance.test_ec2_githubactions.public_ip
}
