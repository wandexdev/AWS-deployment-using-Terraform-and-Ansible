#--------------------------------MAIN LOAD BALANCER RESOURCE-------------------------------#

resource "aws_lb" "wandeminiproject" {
  name                       = "${var.environment_prefix}-ALB"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.wandeminiproject-ALB-SG.id]
  subnets                    = [for subnet in aws_subnet.wandeminiproject : subnet.id]

  tags = {
    Name = "${var.environment_prefix}-ALB"
  }
}

#--------------------------------ALB TARGET GROUP-------------------------------#

resource "aws_lb_target_group" "wandeminiproject" {
  name                       = "${var.environment_prefix}-TG"
  port                       = 80
  protocol                   = "HTTP"
  vpc_id                     = aws_vpc.wandeminiproject.id

  health_check {
    port = 80
    protocol = "HTTP"
    path = "/"
    matcher = "200-299"
  }

  tags = {
    Name = "${var.environment_prefix}-TG"
  }
}

#--------------------------------TG ATTACHMENT-------------------------------#

resource "aws_lb_target_group_attachment" "wandeminiproject" {
  for_each                    = aws_instance.wandeminiproject
  target_group_arn            = aws_lb_target_group.wandeminiproject.arn
  target_id                   = each.value.id
  port                        = 80
}

#--------------------------------HTTPS LISTENER FOR ALB-------------------------------#

resource "aws_lb_listener" "HTTPS" {
  load_balancer_arn           = aws_lb.wandeminiproject.arn
  port                        = 443
  protocol                    = "HTTPS"
  ssl_policy                  = "ELBSecurityPolicy-2016-08"
  certificate_arn             = var.certificate_arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.wandeminiproject.arn
  }

  tags = {
    Name = "${var.environment_prefix}-LT-https"
  }
}

#---------------------------------REDIRECT ACTION---------------------------------------#

resource "aws_lb_listener" "HTTP_TO_HTTPS" {
  load_balancer_arn = aws_lb.wandeminiproject.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}