# AegisCloud — Laboratoire Cloud-Native DevSecOps & GitOps

Laboratoire local et gratuit (aucune ressource AWS payante) qui fait tourner une chaîne
DevSecOps complète : **Git → Jenkins → tests → SonarQube → build → Trivy → registry → ArgoCD → Kubernetes → Prometheus / Grafana / Alertmanager**.

> **Basé sur [CloudDevOpsProject](https://github.com/Waleeddarwesh/CloudDevOpsProject) (licence MIT)** de Waleed Darwesh.
> Le code applicatif, les modules Terraform, les rôles Ansible, les manifests Kubernetes et la shared library Jenkins
> viennent du projet d'origine. Son README est conservé dans [`docs/UPSTREAM-README.md`](docs/UPSTREAM-README.md).

## Environnement

VM Debian 13 (disque externe), Docker, k3s (Kubernetes local), registry `registry:2` sur `localhost:5001`,
Jenkins et SonarQube installés via les rôles Ansible du projet.

## Ce qui a été adapté pour fonctionner en local (mon travail)

| Sujet | Adaptation |
|---|---|
| Cluster | k3s à la place d'EKS ; stockage `local-path` à la place d'EBS (overlay `aegiscloud-local/k8s`) |
| Registry | Registry locale `localhost:5001` à la place d'ECR (`ecrPush` adapté dans ma [shared library](#)) |
| Pipelines | 3 Jenkinsfiles pointés vers ce dépôt ; credential GitHub à droits d'écriture pour pousser les manifests |
| Proxy Jenkins | `jenkins-proxy` redirigé vers le nœud k3s au lieu de l'IP privée AWS de l'auteur (patch d'overlay) |
| Outils | `kustomize` installé sur l'hôte Jenkins ; correctifs Ansible pour SonarQube sous Debian 13 |
| Sécurité du pipeline | Correctifs de dépendances remontés par Trivy (`proxy-addr`, Spring Boot, Tomcat) |
| Exception documentée | `CVE-2026-47884` (spring-webmvc) acceptée dans `.trivyignore` : pas de correctif hors Spring Boot 4, non exploitable (aucun usage de XSLT) |

## État

- 3 pipelines Jenkins verts (auth-service, frontend, roadmap-service), images poussées sur la registry locale.
- ArgoCD en synchronisation automatique ; monitoring opérationnel (16 cibles Prometheus up).
- Terraform validé sans déploiement AWS (`init -backend=false`, `validate`).

## Étape suivante

Audit de sécurité, puis améliorations personnelles (RBAC, NetworkPolicies, secrets, SBOM, signature d'images).
Elles seront ajoutées dans des commits séparés pour les distinguer du projet d'origine.
