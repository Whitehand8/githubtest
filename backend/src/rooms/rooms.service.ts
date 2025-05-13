import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateRoomDto } from './dto/create-room.dto';
import { Room } from './entities/room.entity';

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
}
