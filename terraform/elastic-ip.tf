# --- Elastic IP (IP fixe) ---
resource "aws_eip" "web" {
  instance = aws_instance.web.id
  domain   = "vpc"
  tags     = { Name = "devops-tp-eip" }
}