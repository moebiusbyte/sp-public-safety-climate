resource "kubernetes_namespace" "data_layers" {
  for_each = toset(var.namespace_list)

  metadata {
    name = each.value
  }
}
