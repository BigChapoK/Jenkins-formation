# Utilisation de l'image officielle Eclipse Temurin pour Java 21
FROM eclipse-temurin:21-jre-jammy
# Métadonnées
LABEL maintainer="votre-nom@example.com"
# Dossier de travail
WORKDIR /app
# Copie du JAR généré (on suppose que Maven génère dans target/)
COPY -u root target/*.jar app.jar
# Port exposé par l'application 
EXPOSE 8080
# Commande de démarrage
ENTRYPOINT ["java", "-jar", "app.jar"]
