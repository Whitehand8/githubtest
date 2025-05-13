import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('rooms')
export class Room {
  @PrimaryGeneratedColumn()
  room_number: number; // 자동 증가 PK

  @Column({ length: 100 })
  room_name: string; // 방 이름

  @Column({ length: 255, nullable: true })
  room_password: string | null; // 방 비밀번호 (옵션)

  @Column({ default: 1 })
  room_max: number; // 최대 인원 (1~9)

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date; // 생성 시각

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date; // 수정 시각
}
