
run "test_terraform_practice" {
  command = plan
  # planの実行に必要となる変数を定義
  variables {
    KeyName      = "dummy-key-for-test"
    allowedCIDRs = "0.0.0.0/0"
  }

  # ------------------
  # VPCと関連ネットワークリソースの設定をテスト
  # ------------------
  # 各サブネットのCIDRブロックをテスト
  assert {
    condition = (
      aws_subnet.test_publicsubnet_1a.cidr_block == "10.0.0.0/20" &&
      aws_subnet.test_publicsubnet_1a.availability_zone == "ap-northeast-1a"
    )
    error_message = "VPCのCIDRブロックが期待される値 '10.0.0.0/20' またはアベイラビリティゾーンが一致しません。"
  }
  assert {
    condition = (
      aws_subnet.test_publicsubnet_1c.cidr_block == "10.0.16.0/20" &&
      aws_subnet.test_publicsubnet_1c.availability_zone == "ap-northeast-1c"
    )
    error_message = "VPCのCIDRブロックが期待される値 '10.0.16.0/20' またはアベイラビリティゾーンが一致しません。"
  }
  assert {
    condition = (
      aws_subnet.test_privatesubnet_1a.cidr_block == "10.0.128.0/20" &&
      aws_subnet.test_privatesubnet_1a.availability_zone == "ap-northeast-1a"
    )
    error_message = "VPCのCIDRブロックが期待される値 '10.0.128.0/20' またはアベイラビリティゾーンが一致しません。"
  }
  assert {
    condition = (
      aws_subnet.test_privatesubnet_1c.cidr_block == "10.0.144.0/20" &&
      aws_subnet.test_privatesubnet_1c.availability_zone == "ap-northeast-1c"
    )
    error_message = "VPCのCIDRブロックが期待される値 '10.0.144.0/20' またはアベイラビリティゾーンが一致しません。"
  }
  # パブリックサブネットの設定をテスト (IP自動割当が有効か)
  assert {
    condition     = aws_subnet.test_publicsubnet_1a.map_public_ip_on_launch == true
    error_message = "パブリックサブネット (test_publicsubnet_1a) では、パブリックIPの自動割り当てが有効であるべきです。"
  }
  # プライベートサブネットの設定をテスト (IP自動割当が無効か)
  assert {
    condition     = aws_subnet.test_privatesubnet_1a.map_public_ip_on_launch == false
    error_message = "プライベートサブネット (test_privatesubnet_1a) では、パブリックIPの自動割り当てが無効であるべきです。"
  }
  # 5. S3 VPCエンドポイントのタイプとサービス名をテスト
  assert {
    condition = (
      aws_vpc_endpoint.s3.vpc_endpoint_type == "Gateway" &&
      aws_vpc_endpoint.s3.service_name == "com.amazonaws.ap-northeast-1.s3"
    )
    error_message = "S3 VPCエンドポイントのタイプまたはサービス名が正しくありません。"
  }

  # ------------------
  # EC2の設定値をテスト
  # ------------------
  # ami IDのテスト
  assert {
    condition     = aws_instance.test_ec2.ami == "ami-027fff96cc515f7bc"
    error_message = "CIDR blockがami-027fff96cc515f7bcではありません。"
  }
  # インスタンスタイプのテスト
  assert {
    condition     = aws_instance.test_ec2.instance_type == "t2.micro"
    error_message = "インスタンスタイプがt2.microではありません。"
  }

  # ------------------
  # RDSの設定をテスト
  # ------------------
  # RDSエンジンが MySQL であることを確認
  assert {
    condition     = aws_db_instance.rds.engine == "mysql"
    error_message = "RDSエンジンが'mysql'ではありません。"
  }
  # RDSエンジンのバージョンが 8.0.39 であることを確認
  assert {
    condition     = aws_db_instance.rds.engine_version == "8.0.39"
    error_message = "RDSエンジンのバージョンが'8.0.39'ではありません。"
  }
  # インスタンスクラスが db.t4g.micro であることを確認（コスト効率のよいマイクロインスタンス）
  assert {
    condition     = aws_db_instance.rds.instance_class == "db.t4g.micro"
    error_message = "インスタンスタイプが'db.t4g.micro'ではありません。"
  }
  # ストレージサイズが 20GB に設定されていることを確認（最小限の要件）
  assert {
    condition     = aws_db_instance.rds.allocated_storage == 20
    error_message = "ストレージサイズが20GBではありません。"
  }
  # ストレージタイプが汎用 SSD（gp2）であることを確認
  assert {
    condition     = aws_db_instance.rds.storage_type == "gp2"
    error_message = "ストレージタイプが'gp2'ではありません。"
  }
  # RDSがインターネット経由でアクセスできない（非公開）ことを確認
  assert {
    condition     = aws_db_instance.rds.publicly_accessible == false
    error_message = "publicly_accessible が false（非公開）ではありません。"
  }
  # 削除時に最終スナップショットをスキップする設定が有効であることを確認
  assert {
    condition     = aws_db_instance.rds.skip_final_snapshot == true
    error_message = "skip_final_snapshot が true に設定されていません。"
  }
  # CloudWatch Logs への出力対象として必要なログカテゴリがすべて含まれていることを確認
  assert {
    condition = length(setsubtract(
      ["audit", "error", "general", "slowquery"],
      aws_db_instance.rds.enabled_cloudwatch_logs_exports
    )) == 0
    error_message = "CloudWatchログエクスポートに必要なカテゴリ（audit, error, general, slowquery）がすべて含まれていません。"
  }
}

