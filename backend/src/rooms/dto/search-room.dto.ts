import { IsOptional, IsString, IsInt, Min } from 'class-validator';

export class SearchRoomDto {
  @IsOptional()
  @IsString()
  q?: string; // 방 이름 검색어

  @IsOptional()
  @IsInt()
  @Min(1)
  page?: number = 1; // 페이지 번호

  @IsOptional()
  @IsInt()
  @Min(1)
  limit?: number = 10; // 페이지당 항목 수
}
