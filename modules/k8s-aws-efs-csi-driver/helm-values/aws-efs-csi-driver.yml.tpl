---
serviceAccount:
  controller:
    create: true
    annotations:
      eks.amazonaws.com/role-arn: ${k8s_role_arn}
    name: ${k8s_sa_name}

image:
  repository: amazon/aws-efs-csi-driver
  tag: release-1.2
  pullPolicy: IfNotPresent

sidecars:
  livenessProbeImage:
    repository: public.ecr.aws/eks-distro/kubernetes-csi/livenessprobe
    tag: v2.2.0-eks-1-19-2
  nodeDriverRegistrarImage:
    repository: public.ecr.aws/eks-distro/kubernetes-csi/node-driver-registrar
    tag: v2.1.0-eks-1-19-2
  csiProvisionerImage:
    repository: public.ecr.aws/eks-distro/kubernetes-csi/external-provisioner
    tag: v2.1.1-eks-1-19-2
