//resource "kubernetes_namespace" "echoserver" {
//  metadata {
//    name = "echoserver"
//  }
//}
//
//resource "kubernetes_service" "echoserver" {
//  metadata {
//    name = "echoserver"
//    namespace = kubernetes_namespace.echoserver.metadata[0].name
//  }
//  spec {
//    port {
//      port = 80
//      target_port = 80
//      protocol = "TCP"
//    }
//    type = "NodePort"
//    selector = {
//      app = "echoserver"
//    }
//  }
//}
//
//resource "kubernetes_deployment" "echoserver" {
//  metadata {
//    name = "echoserver"
//    namespace = kubernetes_namespace.echoserver.metadata[0].name
//  }
//  spec {
//    selector {
//      match_labels = {
//        app = "echoserver"
//      }
//    }
//    replicas = 3
//    template {
//      metadata {
//        labels = {
//          app = "echoserver"
//        }
//      }
//      spec {
//        container {
//          image = "nginxdemos/hello:latest"
//          image_pull_policy = "Always"
//          name = "echoserver"
//          port {
//            container_port = 80
//          }
//        }
//      }
//    }
//  }
//}
//
//resource "kubernetes_ingress" "echoserver" {
//  depends_on = [
//    module.alb_ingress
//  ]
//
//  metadata {
//    name = "echoserver"
//    namespace = kubernetes_namespace.echoserver.metadata[0].name
//    annotations = {
//      "kubernetes.io/ingress.class": "alb"
//      "alb.ingress.kubernetes.io/scheme": "internet-facing"
//      "alb.ingress.kubernetes.io/target-type": "ip"
//      "alb.ingress.kubernetes.io/subnets": join(",", module.vpc.public_subnets)
//      "alb.ingress.kubernetes.io/tags": "Environment=dev,Team=test"
//    }
//  }
//  spec {
//    rule {
//      http {
//        path {
//          path = "/"
//          backend {
//            service_name = "echoserver"
//            service_port = "80"
//          }
//        }
//      }
//    }
//  }
//}
