# Linuxtips course: Container architecture on AWS terraform modules

[LinuxTips](https://linuxtips.io/treinamento/arquitetura-de-containers-na-aws/)

Instructor: [Matheus Fidelis](https://linktr.ee/fidelissauro)

[Main respository](https://github.com/ssorato/linuxtips-aws-container-architecture)

| Terraform module                                                                                                                   | Module short description                                      |
|------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| day1  [networking](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day1/README.md)                 | Networking infrastructure                                     |
| day2  [ecs_ec2](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day2/README.md)                    | ECS with EC2 on-demand and spot                               |
| day3  [ecs_app](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day3/ecs_app/README.md)            | ECS demo application                                          |
| day3  [ecs_service](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day3/ecs_service/README.md)    | ECS service with task                                         |
| day4  [ecs_service](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day4/ecs_service/README.md)    | ECS service with autoscaling                                  |
| day5  [ecs_fargate](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day5/ecs_fargate/README.md)    | ECS cluster with only Fargate                                 |
| day6  [ecs_app](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day6/ecs_app/README.md)            | ECS demo application used by CI/CD                            |
| day6  [ecs_service](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day6/ecs_service/README.md)    | ECS service used by CI/CD                                     |
| day7  [ecs_app](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day7/ecs_app/README.md)            | ECS demo application with EFS                                 |
| day7  [ecs_service](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day7/ecs_service/README.md)    | ECS service with EFS                                          |
| day8  [ecs_app](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day8/ecs_app/README.md)            | ECS demo application with Parameters Store and Secret Manager |
| day8  [ecs_service](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day8/ecs_service/README.md)    | ECS service with EFS with Parameters Store and Secret Manager |
| day9  [ecs_fargate](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day9/ecs_fargate/README.md)    | ECS with Fargate, internal ALB, Route53 and service discovery |
| day9  [ecs_service](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day9/ecs_service/README.md)    | ECS service with service discovery                            |
| day10 [ecs_fargate](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day10/ecs_fargate/README.md)   | ECS with Fargate and service connect                          |
| day10 [ecs_service](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day10/ecs_service/README.md)   | ECS service with service connect                              |
| day11 [network](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day11/network/README.md)           | Network infrastructure about ECS and API Gateway              |
| day11 [ecs_fargate](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day11/ecs_fargate/README.md)   | ECS with Fargate used with API Gateway                        |
| day12 [ecs_service](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day12/ecs_service/README.md)   | ECS and CodeDeploy                                            |
| day_13_17 [ECS final project](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day_13_17/README.md) | ECS final project                                             |
| day_18 [networking](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day18/networking/README.md)    | Elastic Kubernetes Service networking                         |
| day_19 [eks-vanilla](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day19/eks-vanilla/README.md)  | Elastic Kubernetes Service Vanilla cluster minimal setup      |
| day_20 [eks-vanilla](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day20/eks-vanilla/README.md)  | Elastic Kubernetes Service Node groups and Cluster Autoscaler |
| day_21 [eks-ec2-fargate](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day21/eks-ec2-fargate/README.md)   | Elastic Kubernetes Service - Cluster EC2 and Fargate  |
| day_21 [eks-full-fargate](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day21/eks-full-fargate/README.md) | Elastic Kubernetes Service - Cluster full Fargate     |
| day_22 [eks-karpenter](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day22/eks-karpenter/README.md) |	Elastic Kubernetes Service - karpenter |
| day_23 [eks-karpenter-groupless](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day23/eks-karpenter-groupless/README.md) | Elastic Kubernetes Service - karpenter groupless and fargate profile |
| day_24 [eks-albc](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day24/eks-albc/README.md) | Elastic Kubernetes Service - AWS Load Balancer Controller |
| day_25 [eks-ingress](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day25/eks-ingress/README.md) | Elastic Kubernetes Service - Others Ingress Controllers |
| day_26 [eks-csi](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day26/eks-csi/README.md) | Elastic Kubernetes Service - POD identity, EBS, S3 and EFS CSI addons |
| day_27 [eks-ext-secrets](https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules/tree/day27/eks-ext-secrets/README.md) | Elastic Kubernetes Service - External Secrets with AWS Secrets Manager |
