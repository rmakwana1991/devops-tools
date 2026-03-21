# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "terraform-ecs-cluster"
}