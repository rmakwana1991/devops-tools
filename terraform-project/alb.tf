# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "terraform-alb"
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  security_groups = [aws_security_group.alb_sg.id]
}