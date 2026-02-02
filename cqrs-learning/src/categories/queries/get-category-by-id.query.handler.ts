// src/categories/queries/get-category-by-id.query.handler.ts
import { QueryHandler, IQueryHandler } from '@nestjs/cqrs';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Logger, NotFoundException } from '@nestjs/common';

import { GetCategoryByIdQuery } from './get-category-by-id.query';
import { Category } from '../models/category.entity';

/**
 * Handler pour GetCategoryByIdQuery
 * Recupere un Category specifique par son ID
 */
@QueryHandler(GetCategoryByIdQuery)
export class GetCategoryByIdQueryHandler implements IQueryHandler<GetCategoryByIdQuery> {
  private readonly logger = new Logger(GetCategoryByIdQueryHandler.name);

  constructor(
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
  ) {}

  async execute(query: GetCategoryByIdQuery): Promise<Category> {
    this.logger.log(`Recuperation du Category ID: ${query.id}`);

    const category = await this.categoryRepository.findOne({
      where: { id: query.id },
    });

    if (!category) {
      throw new NotFoundException(`Category avec l'ID ${query.id} non trouve`);
    }

    return category;
  }
}
