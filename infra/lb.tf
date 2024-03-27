resource "aws_lb" "loadbalancer" {
  count                            = var.enable_loadbalancer?1:0
  name               		   = var.lb_name
  internal           		   = var.lb_internal
  load_balancer_type 		   = var.lb_type
  subnets                          = var.subnet_ids
  security_groups                  = [ aws_security_group.alb[0].id ]
  ip_address_type                  = var.ip_address_type
  enable_deletion_protection       = var.deletion_protection_enabled
}

resource "aws_lb_target_group" "tg" {
  count                = var.enable_loadbalancer?1:0
  name                 = var.target_group_name
  port                 = var.target_group_port
  protocol             = var.target_group_protocal
  target_type          = var.target_group_target_type
  vpc_id               = var.vpc_id
}

resource "aws_lb_listener" "listner1" {
  count             = var.enable_loadbalancer?1:0
  load_balancer_arn = aws_lb.loadbalancer[0].arn
  port 		    = "443"
  protocol          = "HTTPS"
  ssl_policy	    = var.ssl_policy
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[0].arn
  }
}
resource "aws_lb_listener" "listner2" {
  count   = var.enable_loadbalancer?1:0
  load_balancer_arn = aws_lb.loadbalancer[0].arn
  port         = "80"
  protocol     = "HTTP"

  default_action {
    type       = "redirect"

    redirect {
	port     = "443"
	protocol = "HTTPS"
	status_code = "HTTP_301"
    }
  }
}

