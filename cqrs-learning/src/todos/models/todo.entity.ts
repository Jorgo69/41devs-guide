// src/todos/models/todo.entity.ts
// Équivalent d'un Model Eloquent dans Laravel
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('todos') // Nom de la table dans PostgreSQL
export class Todo {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ type: 'boolean', default: false })
  completed: boolean;

  @Column({ type: 'enum', enum: ['low', 'medium', 'high'] })
  priority: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
