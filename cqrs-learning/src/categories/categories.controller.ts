// src/categories/categories.controller.ts
import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  ParseIntPipe,
  Logger,
} from '@nestjs/common';
import { CommandBus, QueryBus } from '@nestjs/cqrs';

// DTOs
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';

// Entity
import { Category } from './models/category.entity';

// Commands
import { CreateCategoryCommand } from './commands/create-category.command';

// Queries
import { GetCategoriesQuery } from './queries/get-categories.query';
import { GetCategoryByIdQuery } from './queries/get-category-by-id.query';

/**
 * Controller pour le module Categories
 * Expose les endpoints REST pour les operations CRUD
 */
@Controller('categories')
export class CategoriesController {
  private readonly logger = new Logger(CategoriesController.name);

  constructor(
    private readonly commandBus: CommandBus,
    private readonly queryBus: QueryBus,
  ) {}

  /**
   * GET /categories
   * Retourne la liste de tous les categories
   */
  @Get()
  async findAll(): Promise<Category[]> {
    this.logger.log('GET /categories');
    return this.queryBus.execute(new GetCategoriesQuery());
  }

  /**
   * GET /categories/:id
   * Retourne un category par son ID
   */
  @Get(':id')
  async findOne(@Param('id', ParseIntPipe) id: number): Promise<Category> {
    this.logger.log(`GET /categories/${id}`);
    return this.queryBus.execute(new GetCategoryByIdQuery(id));
  }

  /**
   * POST /categories
   * Cree un nouveau category
   */
  @Post()
  async create(@Body() dto: CreateCategoryDto): Promise<Category> {
    this.logger.log('POST /categories');
    return this.commandBus.execute(
      new CreateCategoryCommand(dto.name, dto.description),
    );
  }
}

