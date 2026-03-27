# Utilisation de l'image officielle Eclipse Temurin pour Java 17
FROM eclipse-temurin:17-jre-alpine
# Métadonnées
LABEL maintainer="votre-nom@example.com"
# Dossier de travail
WORKDIR /app
# Copie du JAR généré (on suppose que Maven génère dans target/)
COPY target/*.jar mon-app-java.jar
# Port exposé par l'application 
EXPOSE 8080
# Commande de démarrage
ENTRYPOINT ["java", "-jar", "app.jar"]
