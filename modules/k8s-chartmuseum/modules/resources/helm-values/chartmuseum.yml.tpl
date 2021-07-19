---
env:
  open:
    STORAGE: amazon
    STORAGE_AMAZON_REGION: ${aws_region}
    STORAGE_AMAZON_BUCKET: ${s3_bucket_name}
    STORAGE_AMAZON_PREFIX: ${s3_object_key_prefix}
serviceAccount:
  create: true
  name: ${k8s_sa_name}
  annotations:
    eks.amazonaws.com/role-arn: ${iam_role_arn}
