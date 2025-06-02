import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './auth/auth.module';
import { RoomsModule } from './rooms/rooms.module';
import { User } from './auth/entities/user.entity';
import { Room } from './rooms/entities/room.entity';

@Module({
  imports: [
    // 환경변수 글로벌 설정
    ConfigModule.forRoot({ isGlobal: true }),
    // TypeORM 설정: 엔티티 동기화 및 DB 연결
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST,
      port: +process.env.DB_PORT,
      username: process.env.DB_USER,
      password: process.env.DB_PASS,
      database: process.env.DB_NAME,
      entities: [User, Room],
      synchronize: true,
      dropSchema: true,
    }),
    // 기능 모듈 로드
    AuthModule,
    RoomsModule,
  ],
})
export class AppModule {}
