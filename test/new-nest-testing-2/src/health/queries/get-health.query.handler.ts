import { IQueryHandler, QueryHandler } from '@nestjs/cqrs';
import { GetHealthQuery } from './get-health.query';

@QueryHandler(GetHealthQuery)
export class GetHealthQueryHandler implements IQueryHandler<GetHealthQuery> {
  async execute(query: GetHealthQuery) {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      message: 'API NestJS CQRS - 41DEVS Standard',
    };
  }
}
