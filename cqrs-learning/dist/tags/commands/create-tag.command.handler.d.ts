import { ICommandHandler } from "@nestjs/cqrs";
import { CreateTagCommand } from "./create-tag.command";
import { Tag } from "../models/tag.entity";
import { Repository } from "typeorm";
export declare class CreateTagCommandHandler implements ICommandHandler<CreateTagCommand> {
    private readonly tagRepository;
    private readonly logger;
    constructor(tagRepository: Repository<Tag>);
    execute(command: CreateTagCommand): Promise<Tag>;
}
