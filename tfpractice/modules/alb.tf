# ----------
# 変数定義
# ----------

# ----------
# リソース定義
# ----------
# ALB（トラフィックの受け口）
resource "aws_lb" "awsstudy_alb" {
  name               = "awsstudyalb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.test_publicsubnet_1a.id, aws_subnet.test_publicsubnet_1c.id]

  tags = {
    Name = "tf_alb"
  }
}

# ターゲットグループ（トラフィックの転送先を決めるもの）
resource "aws_lb_target_group" "awsstudy_tg" {
  name     = "awsstudytg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200,300,301"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    port                = "traffic-port"
  }

  target_type = "instance"
}

#EC2へ8080番でアクセス
resource "aws_lb_target_group_attachment" "awsstudy_ec2_attach" {
  target_group_arn = aws_lb_target_group.awsstudy_tg.arn
  target_id        = aws_instance.test_ec2.id
  port             = 8080
}

# ALBリスナー（ALBのトラフィックを制御するもの。今回は80番ポートでアクセスがあった場合）
resource "aws_lb_listener" "awsstudy_listener" {
  load_balancer_arn = aws_lb.awsstudy_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.awsstudy_tg.arn
  }
}


