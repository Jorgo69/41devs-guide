import { ICommandHandler } from '@nestjs/cqrs';
import { Repository } from 'typeorm';
import { UpdateTodoCommand } from './update-todo.command';
import { Todo } from '../models/todo.entity';
export declare class UpdateTodoCommandHandler implements ICommandHandler<UpdateTodoCommand> {
    private readonly todoRepository;
    private readonly logger;
    constructor(todoRepository: Repository<Todo>);
    execute(command: UpdateTodoCommand): Promise<Todo>;
}
