# Metric server running on fargate never is ready
# scraper.go:149] "Failed to scrape node" / dial tcp: lookup fargate-ip-100-64-175-192.ec2.internal on 172.20.0.10:53: no such host" 
# https://github.com/kubernetes-sigs/metrics-server/issues/694


resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  namespace  = "kube-system"

  wait = false

  version = var.metrics_server_version

  set {
    name  = "apiService.create"
    value = "true"
  }

  #
  # --kubelet-insecure-tls=true
  # --kubelet-preferred-address-types=InternalIP
  # now metric server is ready ...
  #
  set {
    name  = "extraArgs[0]"
    value = "--kubelet-insecure-tls=true"
  }

  set {
    name  = "extraArgs[1]"
    value = "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname"
  }

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_fargate_profile.kube_system
  ]
}
