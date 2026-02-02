// src/todos/commands/create-todo.command.handler.ts
// ═══════════════════════════════════════════════════════════════════════════
// 🎯 COMMAND HANDLER = Exécute la logique métier de la Command
// C'est ici qu'on fait le travail réel: validation, accès DB, etc.
// ═══════════════════════════════════════════════════════════════════════════

import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Logger } from '@nestjs/common';

import { CreateTodoCommand } from './create-todo.command';
import { Todo } from '../models/todo.entity';

@CommandHandler(CreateTodoCommand) // Lie ce handler à la CreateTodoCommand
export class CreateTodoCommandHandler implements ICommandHandler<CreateTodoCommand> {
  private readonly logger = new Logger(CreateTodoCommandHandler.name);

  constructor(
    @InjectRepository(Todo)
    private readonly todoRepository: Repository<Todo>,
  ) {}

  // La méthode execute() est appelée automatiquement par le CommandBus
  async execute(command: CreateTodoCommand): Promise<Todo> {
    this.logger.log(`📝 Création d'un nouveau Todo: "${command.title}"`);

    // 1. Créer l'entité (comme $todo = new Todo() en Laravel)
    const todo = this.todoRepository.create({
      title: command.title,
      description: command.description,
      completed: false,
      priority: command.priority || 'low',
    });

    // 2. Sauvegarder en base (comme $todo->save() en Laravel)
    const savedTodo = await this.todoRepository.save(todo);

    this.logger.log(`✅ Todo créé avec succès (ID: ${savedTodo.id})`);

    return savedTodo;
  }
}
