// src/todos/queries/get-todo-by-id.query.handler.ts

import { IQueryHandler, QueryHandler } from '@nestjs/cqrs';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Logger, NotFoundException } from '@nestjs/common';

import { GetTodoByIdQuery } from './get-todo-by-id.query';
import { Todo } from '../models/todo.entity';

@QueryHandler(GetTodoByIdQuery)
export class GetTodoByIdQueryHandler implements IQueryHandler<GetTodoByIdQuery> {
  private readonly logger = new Logger(GetTodoByIdQueryHandler.name);

  constructor(
    @InjectRepository(Todo)
    private readonly todoRepository: Repository<Todo>,
  ) {}

  async execute(query: GetTodoByIdQuery): Promise<Todo> {
    this.logger.log(`🔍 Recherche du Todo ID: ${query.id}`);

    const todo = await this.todoRepository.findOne({
      where: { id: query.id },
    });

    if (!todo) {
      throw new NotFoundException(`Todo avec l'ID ${query.id} non trouvé`);
    }

    this.logger.log(`✅ Todo ${query.id} trouvé`);

    return todo;
  }
}
