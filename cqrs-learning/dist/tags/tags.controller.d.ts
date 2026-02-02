import { CommandBus, QueryBus } from '@nestjs/cqrs';
import { Tag } from './models/tag.entity';
import { CreateTagDto } from './dto/create-tag.dto';
export declare class TagsController {
    private readonly commandBus;
    private readonly queryBus;
    private readonly logger;
    constructor(commandBus: CommandBus, queryBus: QueryBus);
    create(dto: CreateTagDto): Promise<Tag>;
}
