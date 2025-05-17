#
# CustomResourceDefinition.apiextensions.k8s.io "scaledjobs.keda.sh" is invalid: 
# metadata.annotations: Too long: may not be more than 262144 bytes
# https://github.com/kedacore/keda/issues/4740
# set server-side apply
# 
resource "kubectl_manifest" "keda" {

  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: keda
  namespace: argocd
spec:
  generators:
    - list:
        elements:
          - cluster: linuxtips-cluster-01
            shard: "01"
          - cluster: linuxtips-cluster-02
            shard: "02"
  template:
    metadata:
      name: keda-{{shard}}
    spec:
      project: "system"
      source:
        repoURL: 'https://kedacore.github.io/charts'
        chart: keda
        targetRevision: "v2.16.1"
        helm:
          releaseName: keda
      destination:
        name: '{{ cluster }}'
        namespace: keda
      syncPolicy:
        syncOptions:
          - CreateNamespace=true
          - ServerSideApply=true
        automated: {}
YAML

  depends_on = [
    helm_release.argocd
  ]

}
