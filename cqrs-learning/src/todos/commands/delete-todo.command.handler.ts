// src/todos/commands/delete-todo.command.handler.ts

import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Logger, NotFoundException } from '@nestjs/common';

import { DeleteTodoCommand } from './delete-todo.command';
import { Todo } from '../models/todo.entity';

@CommandHandler(DeleteTodoCommand)
export class DeleteTodoCommandHandler implements ICommandHandler<DeleteTodoCommand> {
  private readonly logger = new Logger(DeleteTodoCommandHandler.name);

  constructor(
    @InjectRepository(Todo)
    private readonly todoRepository: Repository<Todo>,
  ) {}

  async execute(command: DeleteTodoCommand): Promise<void> {
    this.logger.log(`🗑️ Suppression du Todo ID: ${command.id}`);

    // Vérifier que le Todo existe
    const todo = await this.todoRepository.findOne({
      where: { id: command.id },
    });

    if (!todo) {
      throw new NotFoundException(`Todo avec l'ID ${command.id} non trouvé`);
    }

    // Supprimer
    await this.todoRepository.remove(todo);

    this.logger.log(`✅ Todo ${command.id} supprimé avec succès`);
  }
}
