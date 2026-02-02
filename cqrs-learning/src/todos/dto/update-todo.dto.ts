// src/todos/dto/update-todo.dto.ts
// DTO pour la mise à jour - tous les champs sont optionnels
import { IsString, IsOptional, IsBoolean, MaxLength, IsEnum } from 'class-validator';

export class UpdateTodoDto {
  @IsString()
  @IsOptional()
  @MaxLength(255)
  title?: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsBoolean()
  @IsOptional()
  completed?: boolean;

  @IsEnum(['low', 'medium', 'high'], { message: 'Priority doit être low, medium ou high' })
  @IsOptional()
  priority?: string;
}
