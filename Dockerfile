# 1. OpenJDK를 베이스 이미지로 사용
FROM eclipse-temurin:17-jdk as build

# 2. 작업 디렉토리 설정
WORKDIR /workspace/app

# 3. 빌드에 필요한 파일 복사
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src


# 4. 어플리케이션 빌드
RUN ./gradlew build -x test

# 5. 실행을 위한 새로운 단계
FROM eclipse-temurin:17-jdk

# 6. 빌드 단계에서 생성된 실행 가능한 JAR 파일을 현재 이미지로 복사
COPY --from=build /workspace/app/build/libs/*.jar app.jar

# 7. 컨테이너 시작 시 실행할 명령
ENTRYPOINT ["java","-jar","/app.jar"]
