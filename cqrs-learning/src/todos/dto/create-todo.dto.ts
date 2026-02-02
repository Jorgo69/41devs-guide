// src/todos/dto/create-todo.dto.ts
import { IsString, IsNotEmpty, IsOptional, MaxLength, IsEnum } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateTodoDto {
  @ApiProperty({
    description: 'Titre du todo',
    example: 'Faire les courses',
    maxLength: 255,
  })
  @IsString()
  @IsNotEmpty({ message: 'Le titre est obligatoire' })
  @MaxLength(255, { message: 'Le titre ne doit pas depasser 255 caracteres' })
  title: string;

  @ApiPropertyOptional({
    description: 'Description detaillee du todo',
    example: 'Acheter du lait, du pain et des oeufs',
  })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiPropertyOptional({
    description: 'Priorite du todo',
    enum: ['low', 'medium', 'high'],
    example: 'medium',
  })
  @IsEnum(['low', 'medium', 'high'], {
    message: 'Le choix doit etre entre low, medium ou high',
  })
  @IsOptional()
  priority?: string;
}
