output "policy" {
  value = {
    storage_read      = aws_iam_policy.storage_read
    storage_readwrite = aws_iam_policy.storage_readwrite
  }
}
