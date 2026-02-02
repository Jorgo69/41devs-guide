// src/todos/queries/get-todos.query.handler.ts
// ═══════════════════════════════════════════════════════════════════════════
// 🎯 QUERY HANDLER = Exécute la logique de lecture
// ═══════════════════════════════════════════════════════════════════════════

import { IQueryHandler, QueryHandler } from '@nestjs/cqrs';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Logger } from '@nestjs/common';

import { GetTodosQuery } from './get-todos.query';
import { Todo } from '../models/todo.entity';

@QueryHandler(GetTodosQuery)
export class GetTodosQueryHandler implements IQueryHandler<GetTodosQuery> {
  private readonly logger = new Logger(GetTodosQueryHandler.name);

  constructor(
    @InjectRepository(Todo)
    private readonly todoRepository: Repository<Todo>,
  ) {}

  async execute(query: GetTodosQuery): Promise<Todo[]> {
    this.logger.log('📋 Récupération de la liste des Todos');

    // Créer la requête (comme avec Eloquent Builder en Laravel)
    const queryBuilder = this.todoRepository.createQueryBuilder('todo');

    // Appliquer le filtre si fourni
    if (query.completed !== undefined) {
      queryBuilder.where('todo.completed = :completed', {
        completed: query.completed,
      });
    }

    // Trier par date de création (DESC)
    queryBuilder.orderBy('todo.createdAt', 'DESC');

    const todos = await queryBuilder.getMany();

    this.logger.log(`✅ ${todos.length} Todos trouvés`);

    return todos;
  }
}
