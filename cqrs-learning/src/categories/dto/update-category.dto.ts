// src/categories/dto/update-category.dto.ts
import { PartialType } from '@nestjs/mapped-types';
import { CreateCategoryDto } from './create-category.dto';

/**
 * DTO pour la mise a jour d'un Category
 * Herite de CreateCategoryDto avec tous les champs optionnels
 */
export class UpdateCategoryDto extends PartialType(CreateCategoryDto) {}
