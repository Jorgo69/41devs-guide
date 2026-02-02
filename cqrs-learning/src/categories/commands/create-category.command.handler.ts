// src/categories/commands/create-category.command.handler.ts
import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Logger } from '@nestjs/common';

import { CreateCategoryCommand } from './create-category.command';
import { Category } from '../models/category.entity';

/**
 * Handler pour CreateCategoryCommand
 * Execute la logique metier de creation d'un Category
 */
@CommandHandler(CreateCategoryCommand)
export class CreateCategoryCommandHandler implements ICommandHandler<CreateCategoryCommand> {
  private readonly logger = new Logger(CreateCategoryCommandHandler.name);

  constructor(
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
  ) {}

  async execute(command: CreateCategoryCommand): Promise<Category> {
    this.logger.log(`Creation d'un nouveau Category: "${command.name}"`);

    const category = this.categoryRepository.create({
      name: command.name,
      description: command.description,
    });

    const savedCategory = await this.categoryRepository.save(category);

    this.logger.log(`Category cree avec succes (ID: ${savedCategory.id})`);

    return savedCategory;
  }
}
