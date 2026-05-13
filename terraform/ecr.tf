# --- Registre ECR privé ---
resource "aws_ecr_repository" "app" {
  name                 = "devops-tp-app"
  image_tag_mutability = "MUTABLE"

  # Activation du scan à chaque push
  image_scanning_configuration {
    scan_on_push = true
  }

  # Chiffrement natif du registre
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name   = "devops-tp-ecr"
    Projet = "TP-01414"
  }
}

# --- Politique de cycle de vie : purge automatique des anciennes images ---
resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Conserver les 5 dernières images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = { type = "expire" }
    }]
  })
}

# --- Output : URL du registre (utilisé dans le pipeline CI/CD) ---
output "ecr_repository_url" {
  description = "URL du dépôt ECR pour le push Docker"
  value       = aws_ecr_repository.app.repository_url
}