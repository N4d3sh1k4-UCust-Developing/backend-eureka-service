# Stage 1: Сборка
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app

# Копируем gradle файлы
COPY netflix-eureka/gradlew .
COPY netflix-eureka/gradle gradle
COPY netflix-eureka/build.gradle .
COPY netflix-eureka/settings.gradle .

# Копируем исходники common и самого сервиса
COPY common common
COPY netflix-eureka netflix-eureka

# Собираем сервис (замени :user-service на имя своего модуля)
RUN chmod +x gradlew
RUN ./gradlew build -x test --no-daemon

# Stage 2: Запуск
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
# Копируем только собранный jar
COPY --from=build /app/netflix-eureka/build/libs/*.jar app.jar

# Ограничиваем память внутри JVM
ENTRYPOINT ["java", "-Dspring.profiles.active=prod", "-jar", "app.jar"]