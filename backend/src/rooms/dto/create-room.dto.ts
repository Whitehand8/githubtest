import { IsString, IsOptional, IsInt, Min, Max } from 'class-validator';

// 방 생성 요청 바디 검증용 DTO
export class CreateRoomDto {
  @IsString({ message: '방 이름은 문자열이어야 합니다.' })
  readonly room_name: string;

  @IsOptional()
  @IsString({ message: '비밀번호는 문자열이어야 합니다.' })
  readonly room_password?: string;

  @IsInt({ message: '최대 인원은 숫자여야 합니다.' })
  @Min(1, { message: '최소 인원은 1명입니다.' })
  @Max(9, { message: '최대 인원은 9명입니다.' })
  readonly room_max: number;
}
