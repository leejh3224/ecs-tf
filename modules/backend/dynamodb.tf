locals {
  dynamodb_table_name = "tf-backend-lock"
}

resource "aws_dynamodb_table" "tf_backend_lock" {
  name = local.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(var.common_tags, {
    "name" = local.dynamodb_table_name,
  })
}
