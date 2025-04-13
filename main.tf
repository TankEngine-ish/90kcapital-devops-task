terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"  # my minikube config directory
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  
  }
}

variable "flux_version" {
  description = "Flux version"
  type        = string
  default     = "2.x"
}

variable "flux_registry" {
  description = "Flux container registry"
  type        = string
  default     = "ghcr.io/fluxcd"
}

variable "git_url" {
  description = "Git repository URL"
  type        = string
  default     = "https://github.com/TankEngine-ish/90kcapital-devops-task"
}

variable "git_ref" {
  description = "Git reference (branch, tag, commit)"
  type        = string
  default     = "refs/heads/main"
}

variable "git_path" {
  description = "Path to reconcile within the Git repository"
  type        = string
  default     = "clusters/minikube"
}

# the below variable is just if my repository is private
variable "git_token" {
  description = "GitHub token for private repositories"
  type        = string
  default     = ""
  sensitive   = true
}

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }
}

resource "helm_release" "flux_operator" {
  depends_on = [kubernetes_namespace.flux_system]
  
  name             = "flux-operator"
  namespace        = "flux-system"
  repository       = "oci://ghcr.io/controlplaneio-fluxcd/charts"
  chart            = "flux-operator"
  create_namespace = false  # I've left this just in case Helm decides to create the namespace again
}

resource "helm_release" "flux_instance" {
  depends_on = [helm_release.flux_operator]

  name       = "flux"
  namespace  = "flux-system"
  repository = "oci://ghcr.io/controlplaneio-fluxcd/charts"
  chart      = "flux-instance"

  set {
    name  = "flux.version"
    value = var.flux_version
  }
  
  set {
    name  = "flux.registry"
    value = var.flux_registry
  }
  
  set {
    name  = "git.url"
    value = var.git_url
  }
  
  set {
    name  = "git.ref"
    value = var.git_ref
  }
  
  set {
    name  = "git.path"
    value = var.git_path
  }
  
  # that's just if my repository is private
  dynamic "set" {
    for_each = var.git_token != "" ? [1] : []
    content {
      name  = "git.token"
      value = var.git_token
    }
  }
}