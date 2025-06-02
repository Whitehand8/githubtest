import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateRoomDto } from './dto/create-room.dto';
import { Room } from './entities/room.entity';
import { SearchRoomDto } from './dto/search-room.dto';

@Injectable()
export class RoomsService {
  constructor(
    @InjectRepository(Room)
    private readonly roomsRepo: Repository<Room>,
  ) {}

  // 방 생성 로직
  async create(dto: CreateRoomDto): Promise<Room> {
    const room = this.roomsRepo.create({
      room_name: dto.room_name,
      room_password: dto.room_password ?? null,
      room_max: dto.room_max,
    });
    return await this.roomsRepo.save(room);
  }

  // 방 목록 조회
  async findAll(): Promise<Room[]> {
    return await this.roomsRepo.find();
  }

  // 단일 방 조회
  async findOne(room_number: number): Promise<Room> {
    const room = await this.roomsRepo.findOne({ where: { room_number } });
    if (!room) throw new NotFoundException('해당 방을 찾을 수 없습니다.');
    return room;
  }
  async search(dto: SearchRoomDto): Promise<{ data: Room[]; total: number }> {
    const qb = this.roomsRepo
      .createQueryBuilder('room')
      .where('room.currentMembers > 0');
    if (dto.q) {
      qb.andWhere('room.room_name ILIKE :q', { q: `%${dto.q}%` });
    }
    const [data, total] = await qb
      .orderBy('room.createdAt', 'DESC')
      .skip((dto.page! - 1) * dto.limit!)
      .take(dto.limit!)
      .getManyAndCount();
    return { data, total };
  }

  //인원이 0명인 방 삭제
  async cleanEmptyRooms(): Promise<void> {
    await this.roomsRepo
      .createQueryBuilder()
      .delete()
      .from(Room)
      .where('currentMembers = 0')
      .execute();
  }
}
