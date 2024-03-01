resource "aws_dynamodb_table" "dynamodb_table" {
  name         = var.dynamodb_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_iam_policy" "dynamodb_lock_policy" {
  name        = "dynamodb_lock_policy"
  description = "Grant Terraform specific access to manage state locking in DynamoDB"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Update*",
          "dynamodb:DeleteItem",
        ],
        "Resource" : [
          "arn:aws:dynamodb:*:*:table/${var.dynamodb_name}",
          "arn:aws:dynamodb:*:*:table/${var.dynamodb_name}/index/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "terraform_dynamodb_role" {
  name = "terraform_dynamodb_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "dynamodb.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  role       = aws_iam_role.terraform_dynamodb_role.name
  policy_arn = aws_iam_policy.dynamodb_lock_policy.arn
}
