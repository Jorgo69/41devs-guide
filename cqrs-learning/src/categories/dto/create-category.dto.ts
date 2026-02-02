// src/categories/dto/create-category.dto.ts
import { IsString, IsNotEmpty, IsOptional, MaxLength } from 'class-validator';

/**
 * DTO pour la creation d'un Category
 * Valide les donnees entrantes pour POST /categories
 */
export class CreateCategoryDto {
  @IsString()
  @IsNotEmpty({ message: 'Le nom est obligatoire' })
  @MaxLength(255, { message: 'Le nom ne doit pas depasser 255 caracteres' })
  name: string;

  @IsString()
  @IsOptional()
  description?: string;
}
