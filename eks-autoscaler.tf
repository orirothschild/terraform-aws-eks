## SCALE EC2 - POLICIES ##
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.environment}-ec2-scale-up-policy"
  scaling_adjustment     = var.scale_up_scaling_adjustment
  adjustment_type        = var.scale_up_adjustment_type
  policy_type            = var.scale_up_policy_type
  cooldown               = var.scale_up_cooldown_seconds
  autoscaling_group_name = module.eks.workers_asg_names[1]
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.environment}-ec2-scale-down-policy"
  scaling_adjustment     = var.scale_down_scaling_adjustment
  adjustment_type        = var.scale_down_adjustment_type
  policy_type            = var.scale_down_policy_type
  cooldown               = var.scale_down_cooldown_seconds
  autoscaling_group_name = module.eks.workers_asg_names[1]
}

## SCALE EC2 - Memory BASED ##

resource "aws_cloudwatch_metric_alarm" "mem_high" {
  alarm_name          = "${var.environment}-utilization-scale-memory-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.mem_utilization_high_evaluation_periods
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = var.mem_utilization_high_period_seconds
  statistic           = var.mem_utilization_high_statistic
  threshold           = var.mem_utilization_high_threshold_percent

  dimensions = {
    AutoScalingGroupName = module.eks.workers_asg_names[1]
  }

  alarm_description = "Scale up if Memory utilization is above ${var.mem_utilization_high_threshold_percent} for ${var.mem_utilization_high_period_seconds} seconds"
  alarm_actions     = [join("", aws_autoscaling_policy.scale_up.*.arn)]
}

resource "aws_cloudwatch_metric_alarm" "mem_low" {
  alarm_name          = "${var.environment}-utilization-scale-memory-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.mem_utilization_high_evaluation_periods
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = var.mem_utilization_low_period_seconds
  statistic           = var.mem_utilization_low_statistic
  threshold           = var.mem_utilization_low_threshold_percent

  dimensions = {
    AutoScalingGroupName = module.eks.workers_asg_names[1]
  }

  alarm_description = "Scale down if the Memory utilization is below ${var.cpu_utilization_low_threshold_percent} for ${var.cpu_utilization_low_period_seconds} seconds"
  alarm_actions     = [join("", aws_autoscaling_policy.scale_down.*.arn)]
}

## SCALE EC2 - CPU BASED ##

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.environment}-utilization-scale-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.cpu_utilization_high_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cpu_utilization_high_period_seconds
  statistic           = var.cpu_utilization_high_statistic
  threshold           = var.cpu_utilization_high_threshold_percent

  dimensions = {
    AutoScalingGroupName = module.eks.workers_asg_names[1]
  }

  alarm_description = "Scale up if CPU utilization is above ${var.cpu_utilization_high_threshold_percent} for ${var.cpu_utilization_high_period_seconds} seconds"
  alarm_actions     = [join("", aws_autoscaling_policy.scale_up.*.arn)]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.environment}-utilization-scale-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.cpu_utilization_low_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cpu_utilization_low_period_seconds
  statistic           = var.cpu_utilization_low_statistic
  threshold           = var.cpu_utilization_low_threshold_percent

  dimensions = {
    AutoScalingGroupName = module.eks.workers_asg_names[1]
  }

  alarm_description = "Scale down if the CPU utilization is below ${var.cpu_utilization_low_threshold_percent} for ${var.cpu_utilization_low_period_seconds} seconds"
  alarm_actions     = [join("", aws_autoscaling_policy.scale_down.*.arn)]
}
