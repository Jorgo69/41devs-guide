import { Controller, Get } from '@nestjs/common';
import { QueryBus } from '@nestjs/cqrs';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { GetHealthQuery } from './queries/get-health.query';

@ApiTags('health')
@Controller('health')
export class HealthController {
  constructor(private readonly queryBus: QueryBus) {}

  @Get()
  @ApiOperation({ summary: 'Verifie le statut de l API' })
  @ApiResponse({ status: 200, description: 'API en ligne' })
  async getHealth() {
    return this.queryBus.execute(new GetHealthQuery());
  }
}
