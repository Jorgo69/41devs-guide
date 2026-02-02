// src/categories/categories.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CqrsModule } from '@nestjs/cqrs';

// Controller
import { CategoriesController } from './categories.controller';

// Entity
import { Category } from './models/category.entity';

// Command Handlers
import { CreateCategoryCommandHandler } from './commands/create-category.command.handler';

// Query Handlers
import { GetCategoriesQueryHandler } from './queries/get-categories.query.handler';
import { GetCategoryByIdQueryHandler } from './queries/get-category-by-id.query.handler';

// Regroupement des handlers pour une meilleure lisibilite
const Handlers = [CreateCategoryCommandHandler, GetCategoriesQueryHandler, GetCategoryByIdQueryHandler];

/**
 * Module Categories
 * Regroupe tous les composants lies aux categories
 */
@Module({
  imports: [
    TypeOrmModule.forFeature([Category]),
    CqrsModule,
  ],
  controllers: [CategoriesController],
  providers: [...Handlers],
  exports: [TypeOrmModule],
})
export class CategoriesModule {}

