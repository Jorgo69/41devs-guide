import { ICommandHandler } from '@nestjs/cqrs';
import { Repository } from 'typeorm';
import { DeleteTodoCommand } from './delete-todo.command';
import { Todo } from '../models/todo.entity';
export declare class DeleteTodoCommandHandler implements ICommandHandler<DeleteTodoCommand> {
    private readonly todoRepository;
    private readonly logger;
    constructor(todoRepository: Repository<Todo>);
    execute(command: DeleteTodoCommand): Promise<void>;
}
