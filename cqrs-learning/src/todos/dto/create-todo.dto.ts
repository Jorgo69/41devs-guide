// src/todos/dto/create-todo.dto.ts
// Équivalent d'un FormRequest dans Laravel - Validation des données entrantes
import { IsString, IsNotEmpty, IsOptional, MaxLength, IsEnum } from 'class-validator';

export class CreateTodoDto {
  @IsString()
  @IsNotEmpty({ message: 'Le titre est obligatoire' })
  @MaxLength(255, { message: 'Le titre ne doit pas dépasser 255 caractères' })
  title: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsEnum(
    ['low', 'medium', 'high'],
    {
      message: "Le choix doit etre entre low , medium ou hight"
    }
  )
  @IsOptional()
  priority?: string;
}
