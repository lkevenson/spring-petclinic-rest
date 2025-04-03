# Utilisation d'une image Java 21 comme base
FROM eclipse-temurin:17-jdk AS build

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers Maven et le projet
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

# Donner les permissions au wrapper Maven
RUN chmod +x mvnw

# Construire l'application avec Maven
RUN ./mvnw package -DskipTests

# Utiliser une image plus légère pour exécuter l'application
FROM eclipse-temurin:17-jre

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier JAR généré depuis l'étape précédente
COPY --from=build /app/target/*.jar app.jar

# Exposer le port 9966
EXPOSE 9966

# Lancer l'application Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]
