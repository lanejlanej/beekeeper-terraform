/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

resource "aws_cloudwatch_metric_alarm" "beekeeper_sqs_dlq" {
  alarm_name          = "${var.queue_name}-dlq-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "This alarm monitors the number of messages in the Beekeeper SQS dead letter queue."
  alarm_actions       = ["${aws_sns_topic.beekeeper_sqs_dlq.arn}"]
  treat_missing_data  = "notBreaching"
  tags                = "${var.beekeeper_tags}"

  dimensions = {
    QueueName = "${var.queue_name}-dead-letter"
  }
}
