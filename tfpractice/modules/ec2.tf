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
