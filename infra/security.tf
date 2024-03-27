resource "aws_security_group" "alb" {
  count  = var.enable_loadbalancer?1:0
  name   = format("%s_alb_sg", var.project_name )
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "jenkins" {
  name   = format("%s_master_sg", var.project_name ) 
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "slave" {
  name   = format("%s_slave_sg", var.project_name )
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "slave" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  source_security_group_id       = aws_security_group.jenkins.id
  security_group_id = aws_security_group.slave.id
  depends_on = [ aws_security_group.jenkins, aws_security_group.slave]
}
resource "aws_security_group_rule" "master" {
  count = length(var.master_ingress_rules)
  type              = "ingress"
  from_port         = var.master_ingress_rules[count.index].from_port
  to_port           = var.master_ingress_rules[count.index].to_port
  protocol          = var.master_ingress_rules[count.index].protocol
  cidr_blocks       = [var.master_ingress_rules[count.index].cidr_blocks]
  security_group_id = aws_security_group.jenkins.id
}
resource "aws_security_group_rule" "alb" {
  count             = var.enable_loadbalancer?length(var.alb_ingress_rules):0
  type              = "ingress"
  from_port         = var.alb_ingress_rules[count.index].from_port
  to_port           = var.alb_ingress_rules[count.index].to_port
  protocol          = var.alb_ingress_rules[count.index].protocol
  cidr_blocks       = [var.alb_ingress_rules[count.index].cidr_blocks]
  security_group_id = aws_security_group.alb[0].id
}
