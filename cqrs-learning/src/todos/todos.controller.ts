// src/todos/todos.controller.ts
// ═══════════════════════════════════════════════════════════════════════════
// 🎯 CONTROLLER = Point d'entrée HTTP (comme dans Laravel)
// Mais ici, au lieu d'appeler un Service directement,
// on utilise CommandBus (pour les écritures) et QueryBus (pour les lectures)
// ═══════════════════════════════════════════════════════════════════════════

import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  ParseIntPipe,
  ParseBoolPipe,
  Logger,
} from '@nestjs/common';
import { CommandBus, QueryBus } from '@nestjs/cqrs';

// DTOs
import { CreateTodoDto } from './dto/create-todo.dto';
import { UpdateTodoDto } from './dto/update-todo.dto';

// Commands
import { CreateTodoCommand } from './commands/create-todo.command';
import { UpdateTodoCommand } from './commands/update-todo.command';
import { DeleteTodoCommand } from './commands/delete-todo.command';

// Queries
import { GetTodosQuery } from './queries/get-todos.query';
import { GetTodoByIdQuery } from './queries/get-todo-by-id.query';

// Entity
import { Todo } from './models/todo.entity';

@Controller('todos') // Route: /todos
export class TodosController {
  private readonly logger = new Logger(TodosController.name);

  constructor(
    private readonly commandBus: CommandBus, // Pour les écritures (POST, PUT, DELETE)
    private readonly queryBus: QueryBus, // Pour les lectures (GET)
  ) {}

  // ═══════════════════════════════════════════════════════════════════
  // 📋 GET /todos - Liste tous les todos
  // ═══════════════════════════════════════════════════════════════════
  @Get()
  async findAll(
    @Query('completed', new ParseBoolPipe({ optional: true })) completed?: boolean,
  ): Promise<Todo[]> {
    this.logger.log('GET /todos - Demande de liste');

    // On utilise le QueryBus pour envoyer la Query
    return this.queryBus.execute(new GetTodosQuery(completed));
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🔍 GET /todos/:id - Retourne un todo par son ID
  // ═══════════════════════════════════════════════════════════════════
  @Get(':id')
  async findOne(@Param('id', ParseIntPipe) id: number): Promise<Todo> {
    this.logger.log(`GET /todos/${id} - Demande de détail`);

    return this.queryBus.execute(new GetTodoByIdQuery(id));
  }

  // ═══════════════════════════════════════════════════════════════════
  // ➕ POST /todos - Crée un nouveau todo
  // ═══════════════════════════════════════════════════════════════════
  @Post()
  async create(@Body() dto: CreateTodoDto): Promise<Todo> {
    this.logger.log('POST /todos - Création');

    // On utilise le CommandBus pour envoyer la Command
    return this.commandBus.execute(
      new CreateTodoCommand(dto.title, dto.description, dto.priority),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // ✏️ PATCH /todos/:id - Met à jour un todo
  // ═══════════════════════════════════════════════════════════════════
  @Patch(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateTodoDto,
  ): Promise<Todo> {
    this.logger.log(`PATCH /todos/${id} - Mise à jour`);

    return this.commandBus.execute(
      new UpdateTodoCommand(id, dto.title, dto.description, dto.completed, dto.priority),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // 🗑️ DELETE /todos/:id - Supprime un todo
  // ═══════════════════════════════════════════════════════════════════
  @Delete(':id')
  async remove(@Param('id', ParseIntPipe) id: number): Promise<{ message: string }> {
    this.logger.log(`DELETE /todos/${id} - Suppression`);

    await this.commandBus.execute(new DeleteTodoCommand(id));

    return { message: `Todo ${id} supprimé avec succès` };
  }
}
