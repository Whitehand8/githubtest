import {
  Controller,
  Post,
  Get,
  Body,
  Param,
  ParseIntPipe,
} from '@nestjs/common';
import { RoomsService } from './rooms.service';
import { CreateRoomDto } from './dto/create-room.dto';
import { Room } from './entities/room.entity';
import { SearchRoomDto } from './dto/search-room.dto';
import { Query } from '@nestjs/common/decorators/http/route-params.decorator';

@Controller('rooms')
export class RoomsController {
  constructor(private readonly roomsService: RoomsService) {}

  // POST /rooms
  @Post()
  create(@Body() dto: CreateRoomDto): Promise<Room> {
    return this.roomsService.create(dto);
  }

  // GET /rooms
  @Get()
  findAll(): Promise<Room[]> {
    return this.roomsService.findAll();
  }

  // GET /rooms/:room_number
  @Get(':room_number')
  findOne(
    @Param('room_number', ParseIntPipe) room_number: number,
  ): Promise<Room> {
    return this.roomsService.findOne(room_number);
  }

  @Get('search')
  search(@Query() dto: SearchRoomDto) {
    return this.roomsService.search(dto);
  }
}
