resource "aws_launch_template" "template" {
  name_prefix = "${var.project_name}-lt-"
  image_id = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.ec2_security_group_id]
  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update -y
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx
    EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
        Name = "${var.project_name}-app"
        Environment = var.environment
    }
    }
  }


resource "aws_autoscaling_group" "asg" {
  name = "${var.project_name}-asg"
  vpc_zone_identifier = var.private_app_subnet_ids
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
  launch_template {
    id = aws_launch_template.template.id
    version = "$Latest"
  }
  tag {
   key = "Name"
   value = "${var.project_name}-asg"
   propagate_at_launch = true
  }

  tag {
   key= "Environment"
   value = var.environment
   propagate_at_launch = true
  }
}
