resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/java-web-app"
  retention_in_days = 30

  tags = {
    Name = "/ecs/java-web-app"
  }
}
