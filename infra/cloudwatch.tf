resource "aws_cloudwatch_log_group" "main" {
  name              = var.awslogs_group
  retention_in_days = 90
}
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_alarm" {
  alarm_name          = "ecs-cpu-utilization-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when ECS CPU utilization exceeds 80%"
  alarm_actions       = var.sns 
  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
    ServiceName = aws_ecs_service.service.name
  }
}

