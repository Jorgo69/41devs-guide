// src/main.ts
// Point d'entrée de l'application NestJS

import { NestFactory } from '@nestjs/core';
import { ValidationPipe, Logger } from '@nestjs/common';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const logger = new Logger('Bootstrap');

  // Activer la validation globale des DTOs
  // C'est comme le middleware de validation dans Laravel
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true, // Supprime les propriétés non déclarées dans le DTO
      forbidNonWhitelisted: true, // Renvoie une erreur si propriétés inconnues
      transform: true, // Transforme automatiquement les types (string -> number, etc.)
      transformOptions: {
        enableImplicitConversion: true, // Conversion implicite des types
      },
    }),
  );

  // Préfixe global pour l'API (optionnel)
  // app.setGlobalPrefix('api');

  const port = process.env.PORT || 3000;
  await app.listen(port);

  logger.log(`🚀 Application en cours d'exécution sur: http://localhost:${port}`);
  logger.log(`📝 API Todos: http://localhost:${port}/todos`);
}

bootstrap();
