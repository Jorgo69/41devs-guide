import { IQueryHandler } from '@nestjs/cqrs';
import { Repository } from 'typeorm';
import { GetTodoByIdQuery } from './get-todo-by-id.query';
import { Todo } from '../models/todo.entity';
export declare class GetTodoByIdQueryHandler implements IQueryHandler<GetTodoByIdQuery> {
    private readonly todoRepository;
    private readonly logger;
    constructor(todoRepository: Repository<Todo>);
    execute(query: GetTodoByIdQuery): Promise<Todo>;
}
