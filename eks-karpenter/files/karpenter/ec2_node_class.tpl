apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass
metadata:
  name: ${NAME}
spec:
  instanceProfile: "${INSTANCE_PROFILE}"
  amiFamily: "${AMI_FAMILY}"
  amiSelectorTerms:
  - id: ${AMI_ID}
  securityGroupSelectorTerms:
  - id: ${SECURITY_GROUP_ID}
  subnetSelectorTerms:
%{ for subnet in SUBNETS ~}
  - id: ${subnet}
%{ endfor ~}
