---
installCRDs: true

serviceAccount:
  create: true
  name: ${cert_manager_service_account_name}
  automountServiceAccountToken: true
  annotations:
    eks.amazonaws.com/role-arn: ${cert_manager_iam_role_arn}
