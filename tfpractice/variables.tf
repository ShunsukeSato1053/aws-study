# ----------
# 変数定義
# ----------
# cidrblock
variable "my_cidr_block" {
  default = "10.0.0.0/16"
}

# ciderblock(自身のPCからのみ許可)
variable "allowedCIDRs" {
  type        = string
  description = "KeyPairの設定用変数"
}
