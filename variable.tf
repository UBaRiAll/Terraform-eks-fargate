variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  #값 입력
  default     = "ub-cluster"
}

variable "cluster_version" {
  description = "The desired Kubernetes version for the EKS cluster"
  type        = string
  #값 입력
  default     = "1.28"
}

