import {
  Entity,
  Column,
  PrimaryColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

/// users 테이블과 매핑되는 엔티티 클래스
@Entity('users')
export class User {
  /** 아이디(Primary Key) */
  @PrimaryColumn({ length: 50 })
  id: string;

  /** 해시된 비밀번호를 저장할 컬럼 */
  @Column({ name: 'password_hash', length: 255 })
  passwordHash: string;

  /** 이메일(중복 방지 위해 unique) */
  @Column({ unique: true, length: 100 })
  email: string;

  /** 전화번호 */
  @Column({ length: 20 })
  phone: string;

  /** 레코드 생성 시각 (자동 저장) */
  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  /** 레코드 수정 시각 (자동 저장) */
  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
