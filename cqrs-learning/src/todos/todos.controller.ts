// src/todos/todos.controller.ts
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
import { ApiTags, ApiOperation, ApiResponse, ApiParam, ApiQuery } from '@nestjs/swagger';

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

@ApiTags('todos')
@Controller('todos')
export class TodosController {
  private readonly logger = new Logger(TodosController.name);

  constructor(
    private readonly commandBus: CommandBus,
    private readonly queryBus: QueryBus,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Liste tous les todos' })
  @ApiQuery({ name: 'completed', required: false, type: Boolean })
  @ApiResponse({ status: 200, description: 'Liste des todos' })
  async findAll(
    @Query('completed', new ParseBoolPipe({ optional: true })) completed?: boolean,
  ): Promise<Todo[]> {
    this.logger.log('GET /todos');
    return this.queryBus.execute(new GetTodosQuery(completed));
  }

  @Get(':id')
  @ApiOperation({ summary: 'Retourne un todo par son ID' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Le todo demande' })
  @ApiResponse({ status: 404, description: 'Todo non trouve' })
  async findOne(@Param('id', ParseIntPipe) id: number): Promise<Todo> {
    this.logger.log(`GET /todos/${id}`);
    return this.queryBus.execute(new GetTodoByIdQuery(id));
  }

  @Post()
  @ApiOperation({ summary: 'Cree un nouveau todo' })
  @ApiResponse({ status: 201, description: 'Todo cree avec succes' })
  @ApiResponse({ status: 400, description: 'Donnees invalides' })
  async create(@Body() dto: CreateTodoDto): Promise<Todo> {
    this.logger.log('POST /todos');
    return this.commandBus.execute(
      new CreateTodoCommand(dto.title, dto.description, dto.priority),
    );
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Met a jour un todo' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Todo mis a jour' })
  @ApiResponse({ status: 404, description: 'Todo non trouve' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateTodoDto,
  ): Promise<Todo> {
    this.logger.log(`PATCH /todos/${id}`);
    return this.commandBus.execute(
      new UpdateTodoCommand(id, dto.title, dto.description, dto.completed, dto.priority),
    );
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Supprime un todo (soft delete)' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'Todo supprime' })
  @ApiResponse({ status: 404, description: 'Todo non trouve' })
  async remove(@Param('id', ParseIntPipe) id: number): Promise<{ message: string }> {
    this.logger.log(`DELETE /todos/${id}`);
    await this.commandBus.execute(new DeleteTodoCommand(id));
    return { message: `Todo ${id} supprime avec succes` };
  }
}

