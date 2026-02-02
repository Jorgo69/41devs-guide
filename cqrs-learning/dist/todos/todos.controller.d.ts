import { CommandBus, QueryBus } from '@nestjs/cqrs';
import { CreateTodoDto } from './dto/create-todo.dto';
import { UpdateTodoDto } from './dto/update-todo.dto';
import { Todo } from './models/todo.entity';
export declare class TodosController {
    private readonly commandBus;
    private readonly queryBus;
    private readonly logger;
    constructor(commandBus: CommandBus, queryBus: QueryBus);
    findAll(completed?: boolean): Promise<Todo[]>;
    findOne(id: number): Promise<Todo>;
    create(dto: CreateTodoDto): Promise<Todo>;
    update(id: number, dto: UpdateTodoDto): Promise<Todo>;
    remove(id: number): Promise<{
        message: string;
    }>;
}
