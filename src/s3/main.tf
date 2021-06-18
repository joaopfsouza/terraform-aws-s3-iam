resource "aws_s3_bucket" "s3" {
  for_each = { for s in var.s3 : s.s3_name => s }
  bucket   = "${each.value.s3_name}${local.prefix_environment}"
  tags     = merge(local.tags, { sn-produto = "${each.value.sn_produto}", sn-modulo = "${each.value.sn_modulo}" })
}

resource "aws_iam_user" "iam_user" {
  for_each = { for u in var.iam_user_s3 : u.user_name => u }
  name     = "${each.value.user_name}${local.prefix_environment}"
  tags     = merge(local.tags, { sn-produto = "${each.value.user_name}", sn-modulo = "${each.value.user_name}" })
}

resource "aws_iam_access_key" "iam_user_acces_key" {
  for_each = toset([for u in aws_iam_user.iam_user : u.name])
  user     = each.value
}


resource "aws_iam_user_policy" "iam_user_policy" {
  for_each = { for u in var.iam_user_s3 : u.user_name => u }
  name     = "policy-s3-${each.value.user_name}${local.prefix_environment}"
  user     = each.value.user_name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "s3:*"
          ],
          "Effect" : "Allow",
          "Resource" : formatlist("arn:aws:s3:::%s${local.prefix_environment}", each.value.s3_access)
        }
      ]
  })
}


resource "aws_ssm_parameter" "access_key_id" {
  for_each = { for k in aws_iam_access_key.iam_user_acces_key : k.user => k }
  name     = "acces-key-id-${each.value.user}"
  type     = "SecureString"
  value    = each.value.id
}

resource "aws_ssm_parameter" "access_key_secret" {
  for_each = { for k in aws_iam_access_key.iam_user_acces_key : k.user => k }
  name     = "acces-key-secret-${each.value.user}"
  type     = "SecureString"
  value    = each.value.id
}
