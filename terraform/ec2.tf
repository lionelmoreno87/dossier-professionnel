# --- Clé SSH ---
resource "aws_key_pair" "devops" {
  key_name   = "devops-tp-key"
  public_key = file("~/.ssh/devops_tp_key.pub")
}

# --- Instance EC2 ---
resource "aws_instance" "web" {
  # Ubuntu 22.04 LTS (AMI officielle Canonical - région Paris)
  ami                    = "ami-0f61de2873e29e866"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.devops.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]  

  # Script d'initialisation automatique
user_data = file("scripts/user_data.sh")

  # Stockage chiffré
  root_block_device {               
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name   = "devops-tp-serveur-web"
    Projet = "TP-01414"
  }
}

