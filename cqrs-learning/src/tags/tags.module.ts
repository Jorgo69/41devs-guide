// src/tags/tags.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CqrsModule } from '@nestjs/cqrs';

// Controller
import { TagsController } from './tags.controller';

// Entity
import { Tag } from './models/tag.entity';

// Command Handlers
import { CreateTagCommandHandler } from './commands/create-tag.command.handler';

// Tous les handlers à enregistrer
const CommandHandlers = [CreateTagCommandHandler];

@Module({
  imports: [
    TypeOrmModule.forFeature([Tag]), // Enregistre l'entité Tag
    CqrsModule, // Nécessaire pour CommandBus/QueryBus
  ],
  controllers: [TagsController],
  providers: [...CommandHandlers],
})
export class TagsModule {}
