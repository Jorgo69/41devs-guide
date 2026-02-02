import { ICommandHandler } from '@nestjs/cqrs';
import { Repository } from 'typeorm';
import { CreateTodoCommand } from './create-todo.command';
import { Todo } from '../models/todo.entity';
export declare class CreateTodoCommandHandler implements ICommandHandler<CreateTodoCommand> {
    private readonly todoRepository;
    private readonly logger;
    constructor(todoRepository: Repository<Todo>);
    execute(command: CreateTodoCommand): Promise<Todo>;
}
