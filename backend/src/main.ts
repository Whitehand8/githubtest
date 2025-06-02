import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // === 여기에 CORS 설정을 추가하세요 ===
  app.enableCors({
    origin: true, // Flutter Web이 띄워진 주소(포트)
    credentials: true,
    methods: ['GET', 'HEAD', 'PUT', 'PATCH', 'POST', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    optionsSuccessStatus: 204, // 프리플라이트 응답을 204로 반환
  });

  // 외부(Flutter)에서 접속 가능하도록 0.0.0.0 바인딩
  await app.listen(process.env.PORT ?? 3000, '0.0.0.0');
  console.log('NestJS 서버가 http://0.0.0.0:3000 에서 실행 중입니다.');
}
bootstrap();
