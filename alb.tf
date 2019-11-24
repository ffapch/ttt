resource "aws_alb" "ecs-alb" {
  name            = "dev1-ecs-alb"
  security_groups = [aws_security_group.main.id]
  subnets         = [module.subnet1.subnet_id, module.subnet2.subnet_id]
  tags            = var.tags
}

resource "aws_alb_target_group" "ecs-target-group" {
  name     = "dev1-ecs-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "3"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "20"
  }

  tags = var.tags
}

resource "aws_alb_listener" "alb-nginx-listener" {
  load_balancer_arn = aws_alb.ecs-alb.id
  port              = 8080
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ecs-target-group.id
    type             = "forward"
  }
}

//resource "aws_alb_listener" "alb-app-listener" {
//  load_balancer_arn = aws_alb.ecs-alb.arn
//  port = 1234
//  protocol = "http"
//
//  default_action {
//    target_group_arn = aws_lb_target_group.ecs-target-group.arn
//    type = "forward"
//  }
//}