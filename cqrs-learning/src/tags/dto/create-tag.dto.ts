// src/tags/dto/create-tag.dto.ts
import { IsNotEmpty, IsOptional, IsString, Matches, MaxLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateTagDto {
  @ApiProperty({
    description: 'Nom du tag',
    example: 'Urgent',
    maxLength: 50,
  })
  @IsString()
  @MaxLength(50)
  @IsNotEmpty()
  name: string;

  @ApiPropertyOptional({
    description: 'Couleur du tag en hexadecimal',
    example: '#FF5733',
    pattern: '^#[0-9a-fA-F]{6}$',
  })
  @IsString()
  @Matches(/^#[0-9a-fA-F]{6}$/)
  @IsOptional()
  color?: string;
}