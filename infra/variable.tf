variable "deploy_type" {
    type = string
    default = "terraform"
}
variable "region" {
    type = string
    default = "ap-southeast-1"
}

variable "environment" {
    type = string
    default = "prod"
}

variable "project_name" {
    type = string
    default = "jenkins"
}

variable "role_name" {
    type = string
    default = "jenkins_role"
}

variable "policy_name" {
    type = string
    default = "jenkins_policy"
}

variable "ecr_repo_name" {
    type = string
    default = "jenkins_ecr"
}
variable "keyname" {
    type = string
    default = "jenkins"
}
variable "image_version" {
    type = string
    default = "latest"
}

## load balancer
variable "enable_loadbalancer" {
  type = bool
  default = false
}
variable "lb_name" {
   type = string
    default = null
}
variable "lb_internal" {
   type = bool
   default = false
}
variable "lb_type" {
   type = string
   default = "application"
}
variable "subnet_ids" {
   type = list
   default = []
}
variable "ip_address_type" {
  type = string
  default = "ipv4"
}
variable "deletion_protection_enabled" {
  default  = false
}
variable "target_group_name" {
    type = string
    default = null
}
variable "target_group_port" {
    type = number
    default = 8080
}
variable "target_group_protocal" {
   type = string
   default = "HTTP"
}
variable "target_group_target_type" {
   type = string
   default = "ip"
}
variable "vpc_id" {
   type = string
}
variable "ssl_policy" {
   type = string
   default = "ELBSecurityPolicy-2016-08"
}
variable "certificate_arn" {
   type = string
   default = null
}

### ecs
variable "cluster_name" {
   type = string
   default = "jenkins"
}
variable "family" {
  type    = string
  default = "jenkins"
}
variable "cpu" {
  type    = number
  default = 1024
}
variable "memory" {
  type    = number
  default = 2048
}
variable "containername" {
  type = string
  default = "jenkins"
}
variable "service_name" {
   type = string
   default = "jenkins"
}
variable "desired_count" {
  type    = number
  default = 1
}
variable "assign_public_ip" {
   type = bool
   default = true
}
variable "enable__circuit_breaker" {
  type    = bool
  default = true
}
variable "rollback__circuit_breaker" {
  type    = bool
  default = true
}
variable "subnets" {
   type = list
}

# environment variables
variable "jenkins_user" {
   type = string
   default = "admin"
}
variable "jenkins_password" {
   type = string
   default = "123456"
   sensitive = true
}
variable "sshusername" {
   type = string
   default = "ubuntu"
}
variable "ami" {
   type = string
   default = "ami-06c4be2792f419b7b" 
}
variable "associatePublicIp" {
   type = string
   default = "true"
}
variable "slave_label" {
   type = string
   default = "slave"
}
variable "numExecutors" {
   type = string
   default = "2"
}
variable "remoteadmin" {
   type = string
   default = "ubuntu"
}
variable "remotepath" {
   type = string
   default = "/home/ubuntu"
}
variable "slave_subnet_id" {
   type = string
}
variable "slavetype" {
   type = string
   default = "T2Micro"
}
variable "zone" {
   type = string
   default = "ap-southeast-1a"
}

variable "performance_mode" {
   type = string
   default = "generalPurpose"
}
## cloudwatch
variable "awslogs_group" {
   type = string
   default = "jenkins"
}
variable "sns" {
   type = list
   default = [""]
}
## security groups
variable "master_ingress_rules" {
  description = "List of ingress rules to create by name"
      type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = optional(string)
      }))
      default = [
        {
        from_port   = 0
        to_port     = 65536
        protocol    = "-1"
        cidr_blocks = "127.0.0.0/32"
        }
    ]
}
variable "alb_ingress_rules" {
  description = "List of ingress rules to create by name"
      type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks  = optional(string)
      }))
      default = [
        {
        from_port   = 0
        to_port     = 65536
        protocol    = "-1"
        cidr_blocks = "127.0.0.1/32"
        }
    ]
}

