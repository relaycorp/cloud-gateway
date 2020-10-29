output "mongodb_user_name" {
  value = mongodbatlas_database_user.main.username
}
output "mongodb_user_password" {
  value = mongodbatlas_database_user.main.password
}

output "helm_values" {
  value = <<EOF
proxyRequestIdHeader: X-Cloud-Trace-Context

ingress:
  enabled: true
  apiVersion: networking.k8s.io/v1beta1
  annotations:
    kubernetes.io/ingress.global-static-ip-name: ${google_compute_global_address.managed_tls_cert.name}
    networking.gke.io/managed-certificates: gateway-${var.environment_name}
    kubernetes.io/ingress.allow-http: "false"
  enableTls: true

service:
  annotations:
    cloud.google.com/neg: '{"ingress": true}'
  type: NodePort

gatewayKeyId: MTM1NzkK
pohttpHost: ${var.pohttpHost}

powebHost: ${var.powebHost}

cogrpcHost: ${var.cogrpcHost}
cogrpc:
  serviceAnnotations:
    cloud.google.com/app-protocols: '{"cogrpc":"HTTP2"}'
    service.alpha.kubernetes.io/app-protocols: '{"cogrpc":"HTTP2"}'
    cloud.google.com/neg: '{"ingress": true}'
    beta.cloud.google.com/backend-config: '{"ports":{"cogrpc":"cogrpc"}, "default": "cogrpc"}'

mongo:
  uri: ${lookup(mongodbatlas_cluster.main.connection_strings[0], "private_srv", mongodbatlas_cluster.main.mongo_uri)}/${var.mongodb_db_name}

nats:
  serverUrl: nats://example-nats.default.svc.cluster.local:4222
  clusterId: example-stan

objectStore:
  endpoint: minio-test.default.svc.cluster.local:9000
  bucket: public-gateway
  accessKeyId: test-key
  secretKey: test-secret
  tlsEnabled: false

vault:
  serverUrl: http://vault-test.default.svc.cluster.local:8200
  token: letmein
EOF
}

output "gcp_global_ip" {
  value = google_compute_global_address.managed_tls_cert.address
}

output "gcp_crds" {
  value = <<EOF
apiVersion: networking.gke.io/v1beta2
kind: ManagedCertificate
metadata:
  name: gateway-${var.environment_name}
spec:
  domains:
    - ${var.pohttpHost}
    - ${var.powebHost}
    - ${var.cogrpcHost}
---
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: cogrpc
  labels:
    project: ${var.gcp_project_id}
spec:
  healthCheck:
    type: HTTP
    port: 8082
EOF
}
