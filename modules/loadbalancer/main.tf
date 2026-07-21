resource "aws_lb" "load_balancer" {
  name = "${var.project_name}-lb"
  internal = false
  load_balancer_type = "application"

  security_groups = [var.alb_security_group_id]
  subnets = var.public_subnet_ids
}

resource "aws_lb_target_group" "lb_target_group" {
  name = "${var.project_name}-lb-target"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    path= "/"
    port = "traffic-port"
    protocol = "HTTP"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout  = 5
    interval = 30
    matcher = "200"
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }

}

resource "aws_autoscaling_attachment" "asg_att" {
  autoscaling_group_name = var.autoscaling_group_id
  lb_target_group_arn = aws_lb_target_group.lb_target_group.arn
}