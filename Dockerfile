FROM eclipse-temurin:8-alpine
COPY target/ExamThourayaS2-1.jar .
EXPOSE 8083
ENTRYPOINT ["java","-jar","/ExamThourayaS2-1.jar"]