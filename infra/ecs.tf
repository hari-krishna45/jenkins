resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "taskdefinition" {
  family             = var.family
  cpu                = var.cpu
  memory             = var.memory
  network_mode       = "awsvpc"
  execution_role_arn = aws_iam_role.role.arn 
  task_role_arn      = aws_iam_role.role.arn
  requires_compatibilities = ["FARGATE",]
  container_definitions = jsonencode(
          [
            {
              cpu = 0
              environment = [
                {
                  name  = "JENKINS_USER"
                  value = "${var.jenkins_user}"
                },
                {
                  name  = "JENKINS_PASSWORD"
                  value = "${var.jenkins_password}"
                },
                {
                  name  = "SSHUSERNAME"
                  value = "${var.sshusername}"
                },
                {
                  name  = "ACCESSKEY"
                  value = "${aws_iam_access_key.jenkins.id}"
                },
                {
                  name  = "SECREYKEY"
                  value = "${aws_iam_access_key.jenkins.secret}"
                },
                {
                  name  = "REGION"
                  value = "${var.region}"
                },
                {
                  name  = "AMI"
                  value = "${var.ami}"
                },
                {
                  name  = "associatePublicIp"
                  value = "${var.associatePublicIp}"
                },
                {
                  name  = "SLAVE_LABEL"
                  value = "${var.slave_label}"
                },
                {
                  name  = "numExecutors"
                  value = "${var.numExecutors}"
                },
                {
                  name  = "REMOTEADMIN"
                  value = "${var.remoteadmin}"
                },
                {
                  name  = "REMOTEPATH"
                  value = "${var.remotepath}"
                },
                {
                  name  = "SECURITYGROUP"
                  value = "${aws_security_group.slave.id}"
                },
                {
                  name  = "SUBNETID"
                  value = "${var.slave_subnet_id}"
                },
                {
                  name  = "SLAVETYPE"
                  value = "${var.slavetype}"
                },
                {
                  name  = "ZONE"
                  value = "${var.zone}"
                },
              ]
              essential = true
              image     = format("%s:%s", aws_ecr_repository.ecr.repository_url, var.image_version)
              name        = var.containername
              portMappings = [
                {
                  containerPort = 8080
                  hostPort      = 8080
                  protocol      = "tcp"
                },
                {
                  containerPort = 50000
                  hostPort      = 50000
                  protocol      = "tcp"
                }
              ]
              mountPoints = [
                   {
                    "sourceVolume": "jenkins",
                    "containerPath": "/var/jenkins_home",
                    "readOnly": false
                   }
              ]
              logConfiguration = {
                logDriver = "awslogs"
                options = {
                  awslogs-group         = "${var.awslogs_group}" 
                  awslogs-region        = "${var.region}"
                  awslogs-stream-prefix = "ecs"
                }
              }

              volumesFrom = []
            },
         ]
       )
  volume {
    name = "jenkins"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.efs.id
      root_directory          = "/"
      }
    }
  
  depends_on = [null_resource.docker_push, aws_security_group.jenkins, aws_iam_role.role]
}
resource "aws_efs_file_system" "efs" {
   performance_mode = var.performance_mode
   encrypted = true
 tags = {
     Name = "${var.project_name}.efs"
   }
}
resource "aws_efs_mount_target" "efs-mt" {
   count = length(var.subnets)
   file_system_id  = aws_efs_file_system.efs.id
   subnet_id = var.subnets[count.index]
   security_groups = [ "${aws_security_group.slave.id}" ]
}

data "aws_ecs_task_definition" "taskdefinition" {
  task_definition = "${aws_ecs_task_definition.taskdefinition.family}"
}

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = var.cluster_name
  task_definition = "${aws_ecs_task_definition.taskdefinition.family}:${max("${aws_ecs_task_definition.taskdefinition.revision}", "${data.aws_ecs_task_definition.taskdefinition.revision}")}"
  desired_count   = var.desired_count
  enable_ecs_managed_tags = true
  enable_execute_command = true
  launch_type  = "FARGATE"
  propagate_tags = "SERVICE"
  network_configuration {
    assign_public_ip = var.assign_public_ip
    security_groups  = [ aws_security_group.jenkins.id ]
    subnets = var.subnets
  }
  deployment_controller {
    type = "ECS"
  }
  deployment_circuit_breaker {
    enable   =  var.enable__circuit_breaker
    rollback = var.rollback__circuit_breaker
  }
  dynamic "load_balancer" {
    for_each = ( var.enable_loadbalancer?[1] : [] )

    content {
      target_group_arn = aws_lb_target_group.tg[0].arn
      container_name   = var.containername
      container_port   = 8080
    }
  }
  depends_on = [null_resource.docker_push, aws_security_group.jenkins, aws_iam_role.role]
}

