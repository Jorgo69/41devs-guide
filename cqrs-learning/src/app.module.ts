// src/app.module.ts
// Module principal de l'application

import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WinstonModule } from 'nest-winston';
import * as winston from 'winston';

// Modules de l'application
import { TodosModule } from './todos/todos.module';
import { TagsModule } from './tags/tags.module';

@Module({
  imports: [
    // Configuration globale (.env)
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),

    // TypeORM - Connexion PostgreSQL
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get('DATABASE_HOST', 'localhost'),
        port: configService.get<number>('DATABASE_PORT', 5432),
        username: configService.get('DATABASE_USER', 'root'),
        password: configService.get('DATABASE_PASSWORD', 'root'),
        database: configService.get('DATABASE_NAME', 'cqrs_learning'),
        autoLoadEntities: true, // Charge automatiquement les entités
        synchronize: configService.get('NODE_ENV') === 'development', // Crée les tables auto (dev only)
        logging: configService.get('NODE_ENV') === 'development',
      }),
    }),

    // Winston Logger - Logs stylés et détaillés
    WinstonModule.forRoot({
      transports: [
        new winston.transports.Console({
          format: winston.format.combine(
            winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
            winston.format.colorize({ all: true }),
            winston.format.printf(({ timestamp, level, message, context }) => {
              return `[${timestamp}] ${level} [${context || 'App'}]: ${message}`;
            }),
          ),
        }),
      ],
    }),

    // Module Todo (CQRS)
    TodosModule,

    TagsModule,
  ],
})
export class AppModule {}
