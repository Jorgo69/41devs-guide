// src/todos/todos.module.ts
// ═══════════════════════════════════════════════════════════════════════════
// 🎯 MODULE = Regroupement logique (comme un ServiceProvider Laravel)
// C'est ici qu'on déclare tous les composants du module
// ═══════════════════════════════════════════════════════════════════════════

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CqrsModule } from '@nestjs/cqrs';

// Entity
import { Todo } from './models/todo.entity';

// Controller
import { TodosController } from './todos.controller';

// Command Handlers
import { CreateTodoCommandHandler } from './commands/create-todo.command.handler';
import { UpdateTodoCommandHandler } from './commands/update-todo.command.handler';
import { DeleteTodoCommandHandler } from './commands/delete-todo.command.handler';

// Query Handlers
import { GetTodosQueryHandler } from './queries/get-todos.query.handler';
import { GetTodoByIdQueryHandler } from './queries/get-todo-by-id.query.handler';

// Regrouper tous les handlers
const CommandHandlers = [
  CreateTodoCommandHandler,
  UpdateTodoCommandHandler,
  DeleteTodoCommandHandler,
];

const QueryHandlers = [
  GetTodosQueryHandler,
  GetTodoByIdQueryHandler,
];

@Module({
  imports: [
    TypeOrmModule.forFeature([Todo]), // Enregistre l'entité Todo
    CqrsModule, // Active CQRS pour ce module
  ],
  controllers: [TodosController],
  providers: [
    ...CommandHandlers, // Tous les Command Handlers
    ...QueryHandlers, // Tous les Query Handlers
  ],
})
export class TodosModule {}
