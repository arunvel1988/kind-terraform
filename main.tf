terraform {
  required_providers {
    kind = {
      source = "unicell/kind"
      version = "0.0.2-u2"
    }
  }
}


provider "kind" {}

# Create a cluster with kind of the name "test-cluster" with kubernetes version v1.16.1
resource "kind_cluster" "default" {
    name = "test-cluster"
    node_image = "kindest/node:v1.18.4"
    kind_config =<<KIONF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30080
    hostPort: 30070	
- role: worker
KIONF
}	
