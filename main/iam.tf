/**
 * Copyright (C) 2018-2019 Expedia, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */

# ECS execution role
resource "aws_iam_role" "beekeeper_ecs_task_exec" {
  count = "${var.instance_type == "ecs" ? 1 : 0}"
  name  = "${local.instance_alias}-ecs-task-exec-${var.aws_region}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "beekeeper_ecs_task_exec" {
  count      = "${var.instance_type == "ecs" ? 1 : 0}"
  role       = "${aws_iam_role.beekeeper_ecs_task_exec.*.id[0]}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "beekeeper_ecs_task_docker_secrets" {
  count      = "${var.docker_registry_auth_secret_name != "" ? 1 : 0}"
  role       = "${aws_iam_role.beekeeper_path_scheduler_ecs_task.*.id[0]}"
  policy_arn = "${aws_iam_policy.beekeeper_ecs_task_exec_docker_registry.*.arn[0]}"
}

# Path Scheduler ECS task role
resource "aws_iam_role" "beekeeper_path_scheduler_ecs_task" {
  count = "${var.instance_type == "ecs" ? 1 : 0}"
  name  = "${local.instance_alias}-path-scheduler-ecs-task-${var.aws_region}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "beekeeper_path_scheduler_secrets" {
  count      = "${var.instance_type == "ecs" ? 1 : 0}"
  role       = "${aws_iam_role.beekeeper_path_scheduler_ecs_task.*.id[0]}"
  policy_arn = "${aws_iam_policy.beekeeper_secrets.arn}"
}

resource "aws_iam_role_policy_attachment" "beekeeper_path_scheduler_sqs" {
  count      = "${var.instance_type == "ecs" ? 1 : 0}"
  role       = "${aws_iam_role.beekeeper_path_scheduler_ecs_task.*.id[0]}"
  policy_arn = "${aws_iam_policy.beekeeper_sqs.arn}"
}

# Cleanup ECS task role
resource "aws_iam_role" "beekeeper_cleanup_ecs_task" {
  count = "${var.instance_type == "ecs" ? 1 : 0}"
  name  = "${local.instance_alias}-cleanup-ecs-task-${var.aws_region}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "beekeeper_cleanup_secrets" {
  count      = "${var.instance_type == "ecs" ? 1 : 0}"
  role       = "${aws_iam_role.beekeeper_cleanup_ecs_task.*.id[0]}"
  policy_arn = "${aws_iam_policy.beekeeper_secrets.arn}"
}

resource "aws_iam_role_policy_attachment" "beekeeper_cleanup_s3" {
  count      = "${var.instance_type == "ecs" ? 1 : 0}"
  role       = "${aws_iam_role.beekeeper_cleanup_ecs_task.*.id[0]}"
  policy_arn = "${aws_iam_policy.beekeeper_s3.arn}"
}
