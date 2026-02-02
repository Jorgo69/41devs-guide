import { Body, Controller, Post } from '@nestjs/common';
import { CommandBus, QueryBus } from '@nestjs/cqrs';
import { Logger } from '@nestjs/common';
import { CreateTagCommand } from './commands/create-tag.command';
import { Tag } from './models/tag.entity';
import { CreateTagDto } from './dto/create-tag.dto';

@Controller('tags')
export class TagsController {
    private readonly logger = new Logger(TagsController.name);

    constructor(
        private readonly commandBus: CommandBus,
        private readonly queryBus: QueryBus,
    ) {}

    // Pour ajouter
    @Post()
    async create( @Body() dto: CreateTagDto ): Promise<Tag>{
        this.logger.log(`POST / tag - Creation du tag ${dto.name}`);
        return this.commandBus.execute(
            new CreateTagCommand(dto.name, dto.color),
        );
    }
}
