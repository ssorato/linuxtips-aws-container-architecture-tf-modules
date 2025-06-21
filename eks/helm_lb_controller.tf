resource "helm_release" "alb_ingress_controller" {
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "kube-system"
  create_namespace = true

  set = {
    name  = "clusterName"
    value = var.project_name
  }

  set = {
    name  = "serviceAccount.create"
    value = true
  }

  set = {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set = {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_lb_controller.arn
  }

  set = {
    name  = "region"
    value = var.region
  }

  set = {
    name  = "vpcId"
    value = data.aws_ssm_parameter.vpc.value

  }

  # Error: 1 error occurred:
  # * Internal error occurred: failed calling webhook "mservice.elbv2.k8s.aws": failed to call webhook: 
  # Post "https://aws-load-balancer-webhook-service.kube-system.svc:443/mutate-v1-service?timeout=10s": 
  # no endpoints available for service "aws-load-balancer-webhook-service"
  #
  # Turn off mutation webhook for services to avoid ordering issue
  #
  # set {
  #   name  = "enableServiceMutatorWebhook"
  #   value = "false"
  # }

  depends_on = [
    aws_eks_cluster.main,
  ]
}
