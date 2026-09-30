# Imagen base ligera con Nginx
FROM nginx:alpine

# Copiar los archivos del sitio web
COPY src/ /usr/share/nginx/html/

# Puerto que expone el contenedor
EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
