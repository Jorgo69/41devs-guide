// src/categories/queries/get-categories.query.handler.ts
import { QueryHandler, IQueryHandler } from '@nestjs/cqrs';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Logger } from '@nestjs/common';

import { GetCategoriesQuery } from './get-categories.query';
import { Category } from '../models/category.entity';

/**
 * Handler pour GetCategoriesQuery
 * Recupere la liste de tous les Categories
 */
@QueryHandler(GetCategoriesQuery)
export class GetCategoriesQueryHandler implements IQueryHandler<GetCategoriesQuery> {
  private readonly logger = new Logger(GetCategoriesQueryHandler.name);

  constructor(
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
  ) {}

  async execute(query: GetCategoriesQuery): Promise<Category[]> {
    this.logger.log('Recuperation de la liste des Categories');
    return this.categoryRepository.find();
  }
}
