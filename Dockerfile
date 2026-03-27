Dockerfile
# Utilisation d'une image Java légère pour l'exécution
FROM eclipse-temurin:21-jre-alpine

# Métadonnées
LABEL maintainer="votre-nom@example.com"

# Dossier de travail dans le conteneur
WORKDIR /app

# Copie du fichier JAR généré par Maven vers le conteneur
COPY target/*.jar app.jar

# Port exposé par l'application 
EXPOSE 8080

# Commande de démarrage
ENTRYPOINT ["java", "-jar", "app.jar"]
