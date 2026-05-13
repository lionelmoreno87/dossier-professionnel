# Création du Security Group 

resource "aws_security_group" "web_sg" {
  name        = "allow_web_traffic"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.main.id  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.admin_ip}/32"]  
    description = "SSH admin uniquement"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP public"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "devops-tp-sg-web" }
}

# Variable pour votre IP admin
variable "admin_ip" {
  description = "Votre IP publique pour l'accès SSH (sans le /32)"
  type        = string
}
