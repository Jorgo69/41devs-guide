import { CommandHandler, ICommandHandler } from "@nestjs/cqrs";
import { CreateTagCommand } from "./create-tag.command";
import { InjectRepository } from "@nestjs/typeorm";
import { Tag } from "../models/tag.entity";
import { Repository } from "typeorm";
import { Logger } from "@nestjs/common";

@CommandHandler(CreateTagCommand)
export class CreateTagCommandHandler implements ICommandHandler<CreateTagCommand>{
    private readonly logger = new Logger(CreateTagCommandHandler.name);

    constructor(
        @InjectRepository(Tag)
        private readonly tagRepository: Repository<Tag>,
    ){}

    async execute(command: CreateTagCommand): Promise<Tag>{
        this.logger.log(`Creation d'un nouveau : ${command.name}`);

        const tag = this.tagRepository.create({
            name: command.name,
            color: command.color,
        });

        const saveTag = await this.tagRepository.save(tag);

        this.logger.log(`Tag ${saveTag.name} a été créé avec succès`);

        return saveTag;

    }
}