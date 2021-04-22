---
persistence:
  enabled: false
  # type: pvc
  # storageClassName: default
  # accessModes:
  #   - ReadWriteOnce
  # size: 10Gi
  # # annotations: {}
  # finalizers:
  #   - kubernetes.io/pvc-protection
  # # selectorLabels: {}
  # # subPath: ""
  # # existingClaim:

adminUser: admin
# adminPassword: strongpassword

# Use an existing secret for the admin user.
# admin:
#   existingSecret: ""
#   userKey: admin-user
#   passwordKey: admin-password

plugins:
  - grafana-piechart-panel
  - grafana-kubernetes-app

datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
      - name: Prometheus
        type: prometheus
        url: http://${prom_svc}
        access: proxy
        isDefault: true
        basicAuth: false
        withCredentials: false
        editable: true
      - name: Loki
        type: loki
        url: http://${loki_svc}:3100
        isDefault: false
        basicAuth: false
        withCredentials: false
        editable: true

service:
  type: LoadBalancer
  port: 443
  targetPort: 3000
  portName: https
  labels: {}
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: nlb
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http
    service.beta.kubernetes.io/aws-load-balancer-ssl-ports: https
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: ${cert_arn}

