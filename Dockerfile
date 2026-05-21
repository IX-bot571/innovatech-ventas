# --- ETAPA 1: Construcción del Binario (Maven) ---
FROM maven:3.9.6-eclipse-temurin-17-alpine AS build

WORKDIR /app

# Copiar el archivo de configuración de dependencias de Maven
COPY pom.xml .

# Pre-descargar las dependencias para acelerar futuras compilaciones locales
RUN mvn dependency:go-offline -B || true

# Copiar el código fuente del proyecto
COPY src ./src

# Compilar y empaquetar en un archivo .jar, saltando las pruebas unitarias para agilizar
RUN mvn clean package -DskipTests

# --- ETAPA 2: Entorno de Ejecución Seguro (JRE) ---
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Principio DevOps de menor privilegio: Crear grupo y usuario sin permisos de administrador
RUN addgroup -S springgroup && adduser -S springuser -G springgroup

# Copiar el archivo .jar compilado desde la etapa 'build'
COPY --from=build /app/target/*.jar app.jar

# Asignar la propiedad de la aplicación al usuario seguro
RUN chown -R springuser:springgroup /app

# Cambiar el contexto de ejecución al usuario no-root
USER springuser

# Exponer el puerto nativo de Spring Boot
EXPOSE 8080

# Parámetros de optimización para la Máquina Virtual de Java en contenedores
ENV JAVA_OPTS="-XX:+UseG1GC -XX:+UseContainerSupport"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
