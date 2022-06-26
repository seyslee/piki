variable "AWS_REGION" {
  default = "ap-northeast-2"
}

variable "AMIS" {
  type = map(string)

  # [Tips]
  # AMI ID `ami-0cbec04a61be382d9` means
  # Amazon Linux 2 AMI (HVM) - Kernel 5.10
  # SSD Volume Type on ap-northeast-2.
  default = {
    ap-northeast-2 = "ami-0cbec04a61be382d9"
  }
}
