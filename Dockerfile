# Image de base légère
FROM nginx:alpine

# Copie la page web dans le répertoire servi par Nginx
COPY index.html /usr/share/nginx/html/index.html

# Expose le port 80
EXPOSE 80