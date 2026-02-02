// src/main.ts
// Point d'entree de l'application NestJS

import { NestFactory } from '@nestjs/core';
import { ValidationPipe, Logger } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const logger = new Logger('Bootstrap');

  // Prefixe global pour l'API (standard 41DEVS)
  app.setGlobalPrefix('api');

  // Activer la validation globale des DTOs
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  // Configuration Swagger
  const config = new DocumentBuilder()
    .setTitle('CQRS Learning API')
    .setDescription('API NestJS avec CQRS - 41DEVS Standard')
    .setVersion('1.0')
    .addTag('todos', 'Operations sur les Todos')
    .addTag('tags', 'Operations sur les Tags')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  const port = process.env.PORT || 3000;
  await app.listen(port);

  logger.log(`Application en cours d'execution sur: http://localhost:${port}`);
  logger.log(`API Base URL: http://localhost:${port}/api`);
  logger.log(`Swagger Docs: http://localhost:${port}/api/docs`);
}

bootstrap();

