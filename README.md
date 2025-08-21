■AWSハンズオン
→インフラ環境のコード化から完全自動化までを実施

・使用技術・使用ツール
　CloudFormation
　Terraform
　CloudWatch
　S3
　CloudFront
　Lambda
　Lightsail
　GitHubActions
　Ansible

■学習内容
・CloudFormationのテンプレートを用いたインフラ環境構築のコード化
☆工夫した点
　・ハードコーディングにならないように、CloudFormation実行時に入力パラメータを設定できるようにした。（EC2へのSSH接続時に必要なキーペア）
☆対象ファイル
　https://github.com/ShunsukeSato1053/aws-study/blob/main/aws-study.yaml


 ・Terraformを用いたインフラ環境構築のコード化
☆工夫した点
　・ハードコーディングにならないようSSMパラメータストアに、EC2へのSSH接続時に必要なキーペアを登録し、それを呼び出すように設計。
  ・各モジュール毎にファイルを分けることによりリファクタリングをしやすくなるように設計。
☆対象ファイル
　https://github.com/ShunsukeSato1053/aws-study/tree/main/tfpractice
  
   
・CI/CDツール（GitHubActions）を用いてCI/CD環境の構築
☆工夫した点
　・Terraformのテンプレートに修正が加えられた際に自動でterraform testが実行されるようにすることでテストの自動化を実現
☆対象ファイル
　https://github.com/ShunsukeSato1053/aws-study/blob/main/.github/workflows/Terraform-plan.yml
 
  
・プロビジョニングツール（Ansible）を使ったインフラ環境の完全自動化
☆工夫した点
　・AnsibleをGitHubActions経由で動作させるために、GitHubActionsへAnsibleをインストール
  ・Ansibleのファイルに変更があった場合または、Terraformのテンプレートに変更があった際に自動でAnsible deployが実行されるようにすることで完全自動化を実現
☆対象ファイル
　https://github.com/ShunsukeSato1053/aws-study/tree/main/ansible
 https://github.com/ShunsukeSato1053/aws-study/blob/main/.github/workflows/Ansible-deploy.yml
  

