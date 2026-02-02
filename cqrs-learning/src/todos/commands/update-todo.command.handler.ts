// src/todos/commands/update-todo.command.handler.ts

import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Logger, NotFoundException } from '@nestjs/common';

import { UpdateTodoCommand } from './update-todo.command';
import { Todo } from '../models/todo.entity';

@CommandHandler(UpdateTodoCommand)
export class UpdateTodoCommandHandler implements ICommandHandler<UpdateTodoCommand> {
  private readonly logger = new Logger(UpdateTodoCommandHandler.name);

  constructor(
    @InjectRepository(Todo)
    private readonly todoRepository: Repository<Todo>,
  ) {}

  async execute(command: UpdateTodoCommand): Promise<Todo> {
    this.logger.log(`✏️ Mise à jour du Todo ID: ${command.id}`);

    // 1. Vérifier que le Todo existe (comme findOrFail en Laravel)
    const todo = await this.todoRepository.findOne({
      where: { id: command.id },
    });

    if (!todo) {
      throw new NotFoundException(`Todo avec l'ID ${command.id} non trouvé`);
    }

    // 2. Mettre à jour uniquement les champs fournis
    if (command.title !== undefined) todo.title = command.title;
    if (command.description !== undefined) todo.description = command.description;
    if (command.completed !== undefined) todo.completed = command.completed;
    if (command.priority !== undefined) todo.priority = command.priority;

    // 3. Sauvegarder
    const updatedTodo = await this.todoRepository.save(todo);

    this.logger.log(`✅ Todo ${command.id} mis à jour avec succès`);

    return updatedTodo;
  }
}
