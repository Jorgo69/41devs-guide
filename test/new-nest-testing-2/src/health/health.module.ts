import { Module } from '@nestjs/common';
import { CqrsModule } from '@nestjs/cqrs';
import { HealthController } from './health.controller';
import { GetHealthQueryHandler } from './queries/get-health.query.handler';

const QueryHandlers = [GetHealthQueryHandler];

@Module({
  imports: [CqrsModule],
  controllers: [HealthController],
  providers: [...QueryHandlers],
})
export class HealthModule {}
