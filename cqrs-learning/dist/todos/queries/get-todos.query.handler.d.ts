import { IQueryHandler } from '@nestjs/cqrs';
import { Repository } from 'typeorm';
import { GetTodosQuery } from './get-todos.query';
import { Todo } from '../models/todo.entity';
export declare class GetTodosQueryHandler implements IQueryHandler<GetTodosQuery> {
    private readonly todoRepository;
    private readonly logger;
    constructor(todoRepository: Repository<Todo>);
    execute(query: GetTodosQuery): Promise<Todo[]>;
}
