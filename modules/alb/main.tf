resource "aws_lb" "alb" {
  name               = "${var.cluster_name}-${var.cluster_env}-${var.role}"
  internal           = false
  load_balancer_type = "network"
  security_groups    = var.security_group_ids
  subnets            = var.subnets
}

resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.cluster_name}-${var.cluster_env}-${var.role}"
  port        = 443
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    path                = "/ums/check-status"
    port                = "443"
    protocol            = "HTTPS"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    matcher             = "200"
  }

  depends_on = [aws_lb.alb]
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "TCP"
  #certificate_arn   = var.certificate
  #alpn_policy       = "HTTP2Optional"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "one" {
  count = length(var.ec2_instances)

  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = var.ec2_instances[count.index]
  port             = 443
}
