# cert-manager-google-cas-issuer

![Version: v0.0.0](https://img.shields.io/badge/Version-v0.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.0.0](https://img.shields.io/badge/AppVersion-v0.0.0-informational?style=flat-square)

A Helm chart for jetstack/google-cas-issuer

**Homepage:** <https://github.com/jetstack/google-cas-issuer>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| jetstack | <cert-manager-maintainers@jetstack.io> | <https://platform.jetstack.io> |

## Source Code

* <https://github.com/jetstack/google-cas-issuer>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Kubernetes affinity: constraints for pod assignment |
| app.approval | object | `{"enabled":true,"subjects":[{"kind":"ServiceAccount","name":"cert-manager","namespace":"cert-manager"}]}` | Handle RBAC permissions for approving Google CAS issuer CertificateRequests. |
| app.approval.enabled | bool | `true` | enabled determines whether the ClusterRole and ClusterRoleBinding for approval is created. You will want to disable this if you are managing approval RBAC elsewhere from this chart, for example if you create them separately for all installed issuers. |
| app.approval.subjects | list | `[{"kind":"ServiceAccount","name":"cert-manager","namespace":"cert-manager"}]` | subjects is the subject that the approval RBAC permissions will be bound to. Here we are binding them to cert-manager's ServiceAccount so that the default approve all approver has the permissions to do so. You will want to change this subject to approver-policy's ServiceAccount if using that project (recommended).   https://cert-manager.io/docs/projects/approver-policy   name: cert-manager-approver-policy   namespace: cert-manager |
| app.logLevel | int | `1` | Verbosity of google-cas-issuer logging. |
| app.metrics.port | int | `9402` | Port for exposing Prometheus metrics on 0.0.0.0 on path '/metrics'. |
| commonLabels | object | `{}` | Labels to apply to all resources |
| crds.enabled | bool | `true` |  |
| crds.keep | bool | `true` |  |
| deploymentAnnotations | object | `{}` | Optional additional annotations to add to the google-cas-issuer Deployment |
| image.digest | string | `nil` | Target image digest. Will override any tag if set. for example: digest: sha256:0e072dddd1f7f8fc8909a2ca6f65e76c5f0d2fcfb8be47935ae3457e8bbceb20 |
| image.pullPolicy | string | `"IfNotPresent"` | Kubernetes imagePullPolicy on Deployment. |
| image.registry | string | `nil` | Target image registry. Will be prepended to the target image repositry if set. |
| image.repository | string | `"quay.io/jetstack/cert-manager-google-cas-issuer"` | Target image repository. |
| image.tag | string | `nil` | Target image version tag. Defaults to the chart's appVersion. |
| imagePullSecrets | list | `[]` | Optional secrets used for pulling the google-cas-issuer container image. |
| nodeSelector | object | `{}` | Kubernetes node selector: node labels for pod assignment |
| podAnnotations | object | `{}` | Optional additional annotations to add to the google-cas-issuer Pods |
| podLabels | object | `{}` | Optional additional labels to add to the google-cas-issuer Pods |
| priorityClassName | string | `""` | Optional priority class to be used for the google-cas-issuer pods. |
| replicaCount | int | `1` | Number of replicas of google-cas-issuer to run. |
| resources | object | `{}` | Kubernetes pod resource requests/limits for google-cas-issuer. |
| serviceAccount.annotations | object | `{}` | Optional annotations to add to the service account |
| tolerations | list | `[]` | Kubernetes pod tolerations for google-cas-issuer |

