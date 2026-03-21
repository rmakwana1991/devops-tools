# RDS Subnet Group
resource "aws_db_subnet_group" "default" {
  name = "terraform-db-subnet-group"

  subnet_ids = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  tags = {
    Name = "terraform-db-subnet-group"
  }
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name   = "rds-security-group"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
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

# RDS PostgreSQL Instance
resource "aws_db_instance" "postgres" {
  identifier             = "terraform-postgres-db"
  allocated_storage      = 20
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  skip_final_snapshot = true
}