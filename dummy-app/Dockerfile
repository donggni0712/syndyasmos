# 1단계: 의존성 설치 및 빌드
FROM node:16 as builder

# 작업 디렉토리 설정
WORKDIR /app

# package.json과 package-lock.json을 /app에 복사
COPY package*.json ./

# 의존성 설치
RUN npm install

# 나머지 소스 코드 복사
COPY . .

# 2단계: 애플리케이션 실행
FROM node:16-slim

WORKDIR /app

# 빌더 단계에서 빌드한 파일 복사
COPY --from=builder /app .

# 애플리케이션 시작
CMD ["npm", "start"]
