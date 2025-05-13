// backend/src/auth/auth.controller.ts

import { Controller, Post, Body } from '@nestjs/common';
import { AuthService } from './auth.service';
import { CreateUserDto } from './dto/create-user.dto';
import { LoginUserDto } from './dto/login-user.dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('signup')
  async signup(@Body() dto: CreateUserDto) {
    const token = await this.authService.signUp(dto);
    return { token };
  }

  @Post('login')
  async login(@Body() dto: LoginUserDto) {
    const token = await this.authService.login(dto);
    return { token };
  }
}
