output "alb_dns_name" {
  description = "The DNS name of the application load balancer"
  value       = aws_lb.main.dns_name
}

output "jenkins_public_ip" {
  description = "The public IP of the Jenkins server"
  value       = aws_instance.jenkins.public_ip
}

output "sonarqube_public_ip" {
  description = "The public IP of the SonarQube server"
  value       = aws_instance.sonarqube.public_ip
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.app_repo.repository_url
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}
