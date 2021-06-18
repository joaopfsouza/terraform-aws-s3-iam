variable "s3" {
  default = [
    {
      s3_name    = "banana"
      sn_produto = "amarelo"
      sn_modulo  = "amarelo"
    },
    {
      s3_name    = "maca"
      sn_produto = "vermelho"
      sn_modulo  = "vermelho"
    },
    {
      s3_name    = "goiaba"
      sn_produto = "verde"
      sn_modulo  = "verde"
    }
  ]
}

variable "iam_user_s3" {
  default = [
    {
      user_name = "girafa"
      s3_access = ["banana", "maca"]

    },
    {
      user_name = "elefante"
      s3_access = ["maca", "goiaba"]
    }
  ]
}