import { IsString, IsEmail, MinLength, Matches } from 'class-validator';

/// 회원가입 요청 시 들어오는 데이터 구조와 유효성 검사를 정의하는 DTO
export class CreateUserDto {
  /** 아이디(Primary Key용) */
  @IsString({ message: '아이디는 문자열이어야 합니다.' })
  readonly id: string;

  /** 비밀번호(최소 8자) */
  @IsString({ message: '비밀번호는 문자열이어야 합니다.' })
  @MinLength(8, { message: '비밀번호는 최소 8자 이상이어야 합니다.' })
  readonly password: string;

  /** 비밀번호 확인 입력값 */
  @IsString({ message: '비밀번호 확인은 문자열이어야 합니다.' })
  readonly confirmPassword: string;

  /** 이메일 형식 검사 */
  @IsEmail({}, { message: '유효한 이메일 주소를 입력해주세요.' })
  readonly email: string;

  /** 전화번호 형식 검사 (예: 010-1234-5678) */
  @Matches(/^\d{2,3}-\d{3,4}-\d{4}$/, {
    message: '전화번호 형식이 올바르지 않습니다. 예) 010-1234-5678',
  })
  readonly phone: string;
}
