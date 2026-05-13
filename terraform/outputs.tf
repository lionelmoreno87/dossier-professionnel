# --- Outputs ---
output "ip_publique" {
  description = "Adresse IP publique (Elastic IP) du serveur"
  value       = aws_eip.web.public_ip
}

output "url_application" {
  description = "URL pour accéder à l'application"
  value       = "http://${aws_eip.web.public_ip}"
}

output "commande_ssh" {
  description = "Commande pour se connecter au serveur"
  value       = "ssh -i ~/.ssh/devops_key ubuntu@${aws_eip.web.public_ip}"
}