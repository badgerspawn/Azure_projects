output "kubeconfig" {
  description = "Kubeconfig file content"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
}

output "cluster_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.aks.name
}