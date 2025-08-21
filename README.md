# AWS ハンズオン学習記録

本リポジトリは、**インフラ環境のコード化から完全自動化まで**を実施した学習内容をまとめたものです。  
転職活動におけるポートフォリオとして、取り組んだ内容・工夫点・関連ファイルを整理しました。

---

## 🛠️ 使用技術 / 使用ツール
- **IaC (Infrastructure as Code)**
  - CloudFormation
  - Terraform
- **監視 / ログ**
  - CloudWatch
- **ストレージ / 配信**
  - S3
  - CloudFront
- **サーバーレス**
  - Lambda
- **ホスティング**
  - Lightsail
- **自動化 / CI/CD**
  - GitHub Actions
  - Ansible

---

## 📚 学習内容まとめ

### 1. CloudFormation によるインフラ環境構築
- **内容**  
  テンプレートを用いてインフラ環境をコード化し、再現性の高い環境構築を実現。  

- **工夫した点**  
  - ハードコーディングを避けるため、テンプレート実行時に入力パラメータを設定可能に設計  
    （例：EC2 への SSH 接続時に必要なキーペア）

- **対象ファイル**  
  👉 [aws-study.yaml](https://github.com/ShunsukeSato1053/aws-study/blob/main/aws-study.yaml)

---

### 2. Terraform によるインフラ環境構築
- **内容**  
  Terraform を用いてインフラ環境をコード化し、可搬性と再利用性の高い構成を実現。  

- **工夫した点**  
  - SSH接続用のキーペアを **SSM パラメータストア**に登録し、コード内で呼び出すことでハードコーディングを回避  
  - 各モジュールごとにファイルを分割し、リファクタリングしやすい設計に  

- **対象ファイル**  
  👉 [tfpractice ディレクトリ](https://github.com/ShunsukeSato1053/aws-study/tree/main/tfpractice)

---

### 3. GitHub Actions を用いた CI/CD 構築
- **内容**  
  GitHub Actions を活用し、CI/CD パイプラインを構築。  

- **工夫した点**  
  - Terraform のテンプレートに修正が加えられた際に **自動で `terraform test` を実行**  
  - テストの自動化により、コード変更の品質担保を実現

- **対象ファイル**  
  👉 [Terraform-plan.yml](https://github.com/ShunsukeSato1053/aws-study/blob/main/.github/workflows/Terraform-plan.yml)

---

### 4. Ansible を用いた完全自動化
- **内容**  
  プロビジョニングツール Ansible を導入し、環境構築からデプロイまでを完全自動化。  

- **工夫した点**  
  - GitHub Actions 上で Ansible を動作させるため、ワークフロー内で Ansible をインストール  
  - **Terraform または Ansible のファイルに変更があった場合、自動で Ansible Deploy を実行**  
    → 環境構築〜アプリデプロイの完全自動化を実現  

- **対象ファイル**  
  👉 [ansible ディレクトリ](https://github.com/ShunsukeSato1053/aws-study/tree/main/ansible)  
  👉 [Ansible-deploy.yml](https://github.com/ShunsukeSato1053/aws-study/blob/main/.github/workflows/Ansible-deploy.yml)

---

## 🚀 まとめ
本学習を通じて、「インフラのコード化」「テストの自動化」「デプロイの完全自動化」を一連の流れとして実装しました。  
これにより、運用負荷の軽減・人的ミスの防止・継続的な改善が可能なインフラ環境を構築できるスキルを習得しました。

---
