// backend/src/auth/auth.service.ts

import {
  Injectable,
  ConflictException,
  UnauthorizedException,
  BadRequestException,
  InternalServerErrorException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { CreateUserDto } from './dto/create-user.dto';
import { LoginUserDto } from './dto/login-user.dto';
import { User } from './entities/user.entity';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User) private readonly users: Repository<User>,
    private readonly jwtService: JwtService,
  ) {}

  /**
   * 회원가입 처리: 비밀번호 확인 → 해시 → DB 저장 → JWT 반환
   */
  async signUp(dto: CreateUserDto): Promise<string> {
    if (dto.password !== dto.confirmPassword) {
      throw new BadRequestException('비밀번호 확인이 일치하지 않습니다.');
    }
    const exists = await this.users.findOne({ where: { id: dto.id } });
    if (exists) {
      throw new ConflictException('이미 사용 중인 아이디입니다.');
    }
    const hash = await bcrypt.hash(dto.password, 12);
    const user = this.users.create({
      id: dto.id,
      passwordHash: hash,
      email: dto.email,
      phone: dto.phone,
    });
    try {
      await this.users.save(user);
    } catch {
      throw new InternalServerErrorException();
    }
    return this.jwtService.sign({ sub: dto.id });
  }

  /**
   * 로그인 처리: ID/PW 확인 → JWT 반환
   */
  async login(dto: LoginUserDto): Promise<string> {
    const user = await this.users.findOne({ where: { id: dto.id } });
    if (!user) {
      throw new UnauthorizedException('등록된 사용자가 아닙니다.');
    }
    const valid = await bcrypt.compare(dto.password, user.passwordHash);
    if (!valid) {
      throw new UnauthorizedException('비밀번호가 올바르지 않습니다.');
    }
    return this.jwtService.sign({ sub: user.id });
  }
}
