#!/bin/bash

# ============================================================
# 🚀 SETUP-NESTJS-CQRS.SH - Standard 41DEVS
# ============================================================
# Cree par Ibrahim pour 41DEVS
# Version: 2.0.0
# 
# Usage:
#   setup-nestjs-cqrs.sh nom-projet         # Cree le projet avec npm install
#   setup-nestjs-cqrs.sh nom-projet --no-install  # Sans npm install
#   setup-nestjs-cqrs.sh .                  # Dans le dossier actuel
#   setup-nestjs-cqrs.sh                    # Mode interactif
#   setup-nestjs-cqrs.sh -h                 # Affiche l'aide
# ============================================================

set -e

# --- Couleurs ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# --- Variables ---
SKIP_INSTALL=false
PROJECT_NAME=""
PROJECT_DIR=""

# --- Afficher l'aide ---
show_help() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          🚀 SETUP-NESTJS-CQRS - Standard 41DEVS              ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo "  setup-nestjs-cqrs.sh [nom-projet] [options]"
    echo ""
    echo -e "${YELLOW}Arguments:${NC}"
    echo "  nom-projet          Nom du dossier a creer"
    echo "  .                   Initialise dans le dossier actuel"
    echo "  (vide)              Mode interactif"
    echo ""
    echo -e "${YELLOW}Options:${NC}"
    echo "  --no-install, -n    Ne pas executer npm install (pour offline ou vitesse)"
    echo "  --help, -h          Affiche cette aide"
    echo ""
    echo -e "${YELLOW}Exemples:${NC}"
    echo "  setup-nestjs-cqrs.sh mon-api"
    echo "  setup-nestjs-cqrs.sh mon-api --no-install"
    echo "  setup-nestjs-cqrs.sh . -n"
    echo ""
    echo -e "${YELLOW}Apres creation:${NC}"
    echo "  cd mon-api"
    echo "  npm install          # Si --no-install a ete utilise"
    echo "  npm run start:dev"
    echo ""
}

# --- Parser les arguments ---
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -n|--no-install)
                SKIP_INSTALL=true
                shift
                ;;
            *)
                if [[ -z "$PROJECT_NAME" ]]; then
                    PROJECT_NAME="$1"
                fi
                shift
                ;;
        esac
    done
}

# --- Determiner le dossier du projet ---
setup_project_dir() {
    if [[ -n "$PROJECT_NAME" ]]; then
        if [[ "$PROJECT_NAME" == "." ]]; then
            PROJECT_DIR="$(pwd)"
            PROJECT_NAME="$(basename "$PROJECT_DIR")"
            echo -e "${BLUE}📁 Installation dans le dossier actuel: $PROJECT_DIR${NC}"
        else
            PROJECT_DIR="$(pwd)/$PROJECT_NAME"
            
            if [[ -d "$PROJECT_DIR" ]]; then
                echo -e "${RED}❌ Erreur: Le dossier '$PROJECT_NAME' existe deja.${NC}"
                exit 1
            fi
            
            echo -e "${BLUE}📁 Creation du dossier: $PROJECT_DIR${NC}"
            mkdir -p "$PROJECT_DIR"
        fi
    else
        # Mode interactif
        echo -e "${YELLOW}Entrez le nom du projet:${NC}"
        read -r PROJECT_NAME
        
        if [[ -z "$PROJECT_NAME" ]]; then
            echo -e "${RED}❌ Erreur: Le nom du projet est requis.${NC}"
            exit 1
        fi
        
        PROJECT_DIR="$(pwd)/$PROJECT_NAME"
        
        if [[ -d "$PROJECT_DIR" ]]; then
            echo -e "${RED}❌ Erreur: Le dossier '$PROJECT_NAME' existe deja.${NC}"
            exit 1
        fi
        
        echo -e "${YELLOW}Installer les dependances npm? (O/n)${NC}"
        read -r install_choice
        if [[ "$install_choice" =~ ^[Nn]$ ]]; then
            SKIP_INSTALL=true
        fi
        
        echo -e "${BLUE}📁 Creation du dossier: $PROJECT_DIR${NC}"
        mkdir -p "$PROJECT_DIR"
    fi
    
    # Generer le nom de la base de donnees (remplacer - par _)
    DB_NAME="${PROJECT_NAME//-/_}"
}

# --- Afficher le header ---
show_header() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          🚀 SETUP-NESTJS-CQRS - Standard 41DEVS              ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "Projet:     ${GREEN}$PROJECT_NAME${NC}"
    echo -e "Dossier:    ${GREEN}$PROJECT_DIR${NC}"
    echo -e "npm install: ${GREEN}$([ "$SKIP_INSTALL" = true ] && echo "Non" || echo "Oui")${NC}"
    echo ""
}

# --- Creer package.json ---
create_package_json() {
    echo -e "${BLUE}📦 Creation du package.json...${NC}"
    
    cat > "$PROJECT_DIR/package.json" << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "NestJS CQRS - Standard 41DEVS",
  "author": "Ibrahim - 41DEVS",
  "private": true,
  "license": "MIT",
  "scripts": {
    "build": "tsc -p tsconfig.build.json && mkdir -p dist/config && cp -r src/config/*.yml dist/config/",
    "format": "prettier --write \"src/**/*.ts\" \"test/**/*.ts\"",
    "start": "node dist/main.js",
    "start:dev": "nest start --watch",
    "start:debug": "nest start --debug --watch",
    "start:prod": "node dist/main.js",
    "lint": "eslint \"{src,apps,libs,test}/**/*.ts\" --fix",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage",
    "test:e2e": "jest --config ./test/jest-e2e.json",
    "db:setup": "sudo -u postgres psql -f database/setup-database.sql",
    "db:drop": "sudo -u postgres psql -f database/drop-database.sql",
    "db:reset": "npm run db:drop && npm run db:setup"
  },
  "dependencies": {
    "@nestjs/common": "^10.0.0",
    "@nestjs/config": "^4.0.2",
    "@nestjs/core": "^10.0.0",
    "@nestjs/cqrs": "^11.0.3",
    "@nestjs/jwt": "^11.0.0",
    "@nestjs/passport": "^11.0.5",
    "@nestjs/platform-express": "^10.0.0",
    "@nestjs/swagger": "^11.2.0",
    "@nestjs/typeorm": "^9.0.1",
    "bcrypt": "^6.0.0",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.2",
    "js-yaml": "^4.1.0",
    "passport": "^0.7.0",
    "passport-jwt": "^4.0.1",
    "pg": "^8.16.3",
    "reflect-metadata": "^0.2.0",
    "rxjs": "^7.8.1",
    "typeorm": "^0.3.25"
  },
  "devDependencies": {
    "@nestjs/cli": "^10.4.9",
    "@nestjs/schematics": "^10.0.0",
    "@nestjs/testing": "^10.0.0",
    "@types/bcrypt": "^6.0.0",
    "@types/express": "^5.0.0",
    "@types/jest": "^29.5.2",
    "@types/js-yaml": "^4.0.9",
    "@types/node": "^20.3.1",
    "@types/passport": "^1.0.17",
    "@types/passport-jwt": "^4.0.1",
    "@types/supertest": "^6.0.0",
    "@typescript-eslint/eslint-plugin": "^8.0.0",
    "@typescript-eslint/parser": "^8.0.0",
    "eslint": "^8.0.0",
    "eslint-config-prettier": "^9.0.0",
    "eslint-plugin-prettier": "^5.0.0",
    "jest": "^29.5.0",
    "prettier": "^3.0.0",
    "source-map-support": "^0.5.21",
    "supertest": "^7.0.0",
    "ts-jest": "^29.1.0",
    "ts-loader": "^9.4.3",
    "ts-node": "^10.9.1",
    "tsconfig-paths": "^4.2.0",
    "typescript": "^5.1.3"
  },
  "jest": {
    "moduleFileExtensions": ["js", "json", "ts"],
    "rootDir": "src",
    "testRegex": ".*\\\\.spec\\\\.ts$",
    "transform": { "^.+\\\\.(t|j)s$": "ts-jest" },
    "collectCoverageFrom": ["**/*.(t|j)s"],
    "coverageDirectory": "../coverage",
    "testEnvironment": "node"
  }
}
EOF
}

# --- Creer les fichiers de config TypeScript ---
create_ts_config() {
    echo -e "${BLUE}📄 Creation des fichiers TypeScript...${NC}"
    
    # tsconfig.json
    cat > "$PROJECT_DIR/tsconfig.json" << 'EOF'
{
  "compilerOptions": {
    "module": "commonjs",
    "declaration": true,
    "removeComments": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "allowSyntheticDefaultImports": true,
    "target": "ES2021",
    "sourceMap": true,
    "outDir": "./dist",
    "baseUrl": "./",
    "incremental": true,
    "skipLibCheck": true,
    "strictNullChecks": false,
    "noImplicitAny": false,
    "strictBindCallApply": false,
    "forceConsistentCasingInFileNames": false,
    "noFallthroughCasesInSwitch": false
  }
}
EOF

    # tsconfig.build.json
    cat > "$PROJECT_DIR/tsconfig.build.json" << 'EOF'
{
  "extends": "./tsconfig.json",
  "exclude": ["node_modules", "test", "dist", "**/*spec.ts"]
}
EOF

    # nest-cli.json
    cat > "$PROJECT_DIR/nest-cli.json" << 'EOF'
{
  "$schema": "https://json.schemastore.org/nest-cli",
  "collection": "@nestjs/schematics",
  "sourceRoot": "src",
  "compilerOptions": {
    "deleteOutDir": true
  }
}
EOF

    # .prettierrc
    cat > "$PROJECT_DIR/.prettierrc" << 'EOF'
{
  "singleQuote": true,
  "trailingComma": "all"
}
EOF

    # .eslintrc.js
    cat > "$PROJECT_DIR/.eslintrc.js" << 'EOF'
module.exports = {
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: 'tsconfig.json',
    tsconfigRootDir: __dirname,
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint/eslint-plugin'],
  extends: [
    'plugin:@typescript-eslint/recommended',
    'plugin:prettier/recommended',
  ],
  root: true,
  env: {
    node: true,
    jest: true,
  },
  ignorePatterns: ['.eslintrc.js'],
  rules: {
    '@typescript-eslint/interface-name-prefix': 'off',
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-explicit-any': 'off',
  },
};
EOF
}

# --- Creer .gitignore ---
create_gitignore() {
    echo -e "${BLUE}📄 Creation du .gitignore...${NC}"
    
    cat > "$PROJECT_DIR/.gitignore" << 'EOF'
# ============================================================
# .gitignore - Standard 41DEVS
# ============================================================

# Dependencies
node_modules/
**/node_modules/

# Build
dist/
**/dist/
build/

# Environment & Config sensible
.env
.env.*
*.env
!.env.example

# IDE
.idea/
.vscode/
*.swp
*.swo
*.sublime-*

# OS
.DS_Store
Thumbs.db
desktop.ini

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Tests
coverage/
.nyc_output/

# Temp
tmp/
temp/
*.tmp
*.temp

# TypeScript
*.tsbuildinfo

# Optional: Uncomment if you want to include node_modules in repo
# !node_modules/
EOF
}

# --- Creer la structure de dossiers ---
create_directory_structure() {
    echo -e "${BLUE}📁 Creation de la structure 41DEVS...${NC}"
    
    # Structure principale
    mkdir -p "$PROJECT_DIR/src/config"
    mkdir -p "$PROJECT_DIR/src/auth/commands/handlers/create-user.command.handler"
    mkdir -p "$PROJECT_DIR/src/auth/commands/handlers/login.command.handler"
    mkdir -p "$PROJECT_DIR/src/auth/commands/impl/create-user.command"
    mkdir -p "$PROJECT_DIR/src/auth/commands/impl/login.command"
    mkdir -p "$PROJECT_DIR/src/auth/queries/handlers/auth-me.handler"
    mkdir -p "$PROJECT_DIR/src/auth/queries/impl/auth-me.query"
    mkdir -p "$PROJECT_DIR/src/auth/models/user.model"
    mkdir -p "$PROJECT_DIR/src/auth/strategie"
    mkdir -p "$PROJECT_DIR/src/user/commands/handlers/update-user.command.handler"
    mkdir -p "$PROJECT_DIR/src/user/commands/handlers/delete-user.command.handler"
    mkdir -p "$PROJECT_DIR/src/user/commands/impl/update-user.command"
    mkdir -p "$PROJECT_DIR/src/user/commands/impl/delete-user.command"
    mkdir -p "$PROJECT_DIR/src/user/queries/handlers/get-all.handler"
    mkdir -p "$PROJECT_DIR/src/user/queries/handlers/find-by-id.handler"
    mkdir -p "$PROJECT_DIR/src/user/queries/impl/get-all.query"
    mkdir -p "$PROJECT_DIR/src/user/queries/impl/find-by-id.query"
    mkdir -p "$PROJECT_DIR/src/health/queries/handlers/get-health.handler"
    mkdir -p "$PROJECT_DIR/src/health/queries/impl/get-health.query"
    mkdir -p "$PROJECT_DIR/test"
}

# --- Creer les fichiers de configuration ---
create_config_files() {
    echo -e "${BLUE}⚙️ Creation des fichiers de configuration...${NC}"
    
    # default.yml
    cat > "$PROJECT_DIR/src/config/default.yml" << EOF
# ============================================================
# Configuration - Standard 41DEVS
# ============================================================
# Modifier ces valeurs selon votre environnement
# Base de donnees: $DB_NAME

database:
  type: postgres
  host: localhost
  port: 5432
  username: root
  password: root
  database: $DB_NAME
  synchronize: true    # Mettre a false en production!
  logging: true

ssl:
  require: false
  rejectUnauthorized: false

server:
  port: 3000

jwt:
  secret: "CHANGE-ME-IN-PRODUCTION-USE-STRONG-SECRET-KEY"
  expireIn: "7d"

app:
  name: "NestJS CQRS API"
  version: "1.0.0"
EOF

    # configuration.ts
    cat > "$PROJECT_DIR/src/config/configuration.ts" << 'EOF'
/**
 * Configuration Loader - Standard 41DEVS
 * Charge la configuration depuis le fichier YAML
 */
import { readFileSync, existsSync } from 'fs';
import * as yaml from 'js-yaml';
import { join } from 'path';

export default () => {
  const configFileName = 'default.yml';

  // Differents chemins possibles
  const possiblePaths = [
    join(__dirname, configFileName),                    // Dev: src/config/
    join(process.cwd(), 'src', 'config', configFileName), // Depuis racine
    join(process.cwd(), 'dist', 'config', configFileName), // Production
  ];

  let configPath: string | null = null;

  // Trouver le premier chemin qui existe
  for (const path of possiblePaths) {
    if (existsSync(path)) {
      configPath = path;
      break;
    }
  }

  if (!configPath) {
    throw new Error(
      `Configuration file not found. Searched in: ${possiblePaths.join(', ')}`,
    );
  }

  console.log(`📁 Loading configuration from: ${configPath}`);

  return yaml.load(readFileSync(configPath, 'utf8')) as Record<string, any>;
};
EOF
}

# --- Creer les fichiers racine src ---
create_src_root_files() {
    echo -e "${BLUE}📄 Creation des fichiers racine src/...${NC}"
    
    # polyfill.ts
    cat > "$PROJECT_DIR/src/polyfill.ts" << 'EOF'
/**
 * Polyfill - Standard 41DEVS
 * Compatibilite crypto pour Node.js
 */
import { webcrypto } from 'node:crypto';

if (!globalThis.crypto) {
  globalThis.crypto = webcrypto as any;
}
EOF

    # main.ts
    cat > "$PROJECT_DIR/src/main.ts" << 'EOF'
/**
 * Main Bootstrap - Standard 41DEVS
 */
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import './polyfill';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // CORS
  app.enableCors({
    origin: true,
    credentials: true,
  });

  // Validation globale
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
    }),
  );

  // Swagger avec JWT Authentication
  const config = new DocumentBuilder()
    .setTitle('API - Standard 41DEVS')
    .setDescription('NestJS CQRS API Documentation')
    .setVersion('1.0')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        name: 'JWT',
        description: 'Enter JWT token',
        in: 'header',
      },
      'JWT-auth',
    )
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document, {
    swaggerOptions: {
      persistAuthorization: true,
    },
  });

  const port = process.env.PORT ?? 3000;
  await app.listen(port);
  
  console.log('');
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║          🚀 API READY - Standard 41DEVS                      ║');
  console.log('╚══════════════════════════════════════════════════════════════╝');
  console.log(`📍 Server:  http://localhost:${port}`);
  console.log(`📚 Swagger: http://localhost:${port}/api`);
  console.log('');
}
bootstrap();
EOF

    # app.module.ts
    cat > "$PROJECT_DIR/src/app.module.ts" << 'EOF'
/**
 * App Module - Standard 41DEVS
 */
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import configuration from './config/configuration';

// Modules
import { AuthModule } from './auth/auth.module';
import { UserModule } from './user/user.module';
import { HealthModule } from './health/health.module';

// Models
import { UserModel } from './auth/models/user.model/user.model';

@Module({
  imports: [
    // Configuration YAML
    ConfigModule.forRoot({
      load: [configuration],
      isGlobal: true,
    }),

    // TypeORM avec configuration async
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get('database.host'),
        port: configService.get('database.port'),
        username: configService.get('database.username'),
        password: configService.get('database.password'),
        database: configService.get('database.database'),
        entities: [UserModel],
        synchronize: configService.get('database.synchronize'),
        logging: configService.get('database.logging'),
      }),
      inject: [ConfigService],
    }),

    // Modules metier
    AuthModule,
    UserModule,
    HealthModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
EOF

    # app.controller.ts
    cat > "$PROJECT_DIR/src/app.controller.ts" << 'EOF'
/**
 * App Controller - Standard 41DEVS
 */
import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { ApiTags, ApiOperation } from '@nestjs/swagger';

@ApiTags('App')
@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  @ApiOperation({ summary: 'Welcome message' })
  getHello(): string {
    return this.appService.getHello();
  }
}
EOF

    # app.service.ts
    cat > "$PROJECT_DIR/src/app.service.ts" << 'EOF'
/**
 * App Service - Standard 41DEVS
 */
import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Welcome to NestJS CQRS API - Standard 41DEVS';
  }
}
EOF

    # app.controller.spec.ts
    cat > "$PROJECT_DIR/src/app.controller.spec.ts" << 'EOF'
import { Test, TestingModule } from '@nestjs/testing';
import { AppController } from './app.controller';
import { AppService } from './app.service';

describe('AppController', () => {
  let appController: AppController;

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      controllers: [AppController],
      providers: [AppService],
    }).compile();

    appController = app.get<AppController>(AppController);
  });

  describe('root', () => {
    it('should return welcome message', () => {
      expect(appController.getHello()).toBe('Welcome to NestJS CQRS API - Standard 41DEVS');
    });
  });
});
EOF
}

# --- Creer le module Auth ---
create_auth_module() {
    echo -e "${BLUE}🔐 Creation du module Auth...${NC}"
    
    # UserModel
    cat > "$PROJECT_DIR/src/auth/models/user.model/user.model.ts" << 'EOF'
/**
 * User Entity Model - Standard 41DEVS
 */
import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('users')
export class UserModel {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ nullable: false, unique: true })
  email: string;

  @Column({ nullable: true, unique: true })
  username: string;

  @Column({ nullable: true, select: false })
  password: string;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;
}
EOF

    # JWT Strategy
    cat > "$PROJECT_DIR/src/auth/strategie/jwt.strategy.ts" << 'EOF'
/**
 * JWT Strategy - Standard 41DEVS
 */
import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserModel } from '../models/user.model/user.model';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    private configService: ConfigService,
    @InjectRepository(UserModel)
    private userRepository: Repository<UserModel>,
  ) {
    const secret = configService.get<string>('jwt.secret');
    if (!secret) {
      throw new Error('JWT secret is not configured');
    }

    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: secret,
      ignoreExpiration: false,
    });
  }

  async validate(payload: { sub: string; email: string }): Promise<Omit<UserModel, 'password'>> {
    const user = await this.userRepository.findOne({
      where: { email: payload.email },
      select: ['id', 'email', 'username', 'created_at'],
    });

    if (!user) {
      throw new UnauthorizedException('Unauthorized');
    }

    return user;
  }
}
EOF

    # JWT Auth Guard
    cat > "$PROJECT_DIR/src/auth/strategie/jwt-auth.guard.ts" << 'EOF'
/**
 * JWT Auth Guard - Standard 41DEVS
 */
import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
EOF

    # Create User Command (impl)
    cat > "$PROJECT_DIR/src/auth/commands/impl/create-user.command/create-user.command.ts" << 'EOF'
/**
 * Create User Command - Standard 41DEVS
 * Contient les decorateurs de validation et Swagger
 */
import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsOptional, MinLength } from 'class-validator';

export class CreateUserCommand {
  @ApiProperty({
    description: 'Email de l\'utilisateur',
    example: 'user@example.com',
  })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiProperty({
    description: 'Nom d\'utilisateur',
    example: 'john_doe',
    required: false,
  })
  @IsOptional()
  username?: string;

  @ApiProperty({
    description: 'Mot de passe (min 6 caracteres)',
    example: 'password123',
  })
  @IsNotEmpty()
  @MinLength(6)
  password: string;
}
EOF

    # Create User Command Handler
    cat > "$PROJECT_DIR/src/auth/commands/handlers/create-user.command.handler/create-user.command.handler.ts" << 'EOF'
/**
 * Create User Command Handler - Standard 41DEVS
 */
import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { CreateUserCommand } from '../../impl/create-user.command/create-user.command';
import { DataSource } from 'typeorm';
import { ConflictException, Logger } from '@nestjs/common';
import { UserModel } from '../../../models/user.model/user.model';
import * as bcrypt from 'bcrypt';

@CommandHandler(CreateUserCommand)
export class CreateUserCommandHandler implements ICommandHandler<CreateUserCommand> {
  private readonly logger = new Logger(CreateUserCommandHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(command: CreateUserCommand): Promise<any> {
    try {
      const userRepository = this.dataSource.getRepository(UserModel);

      // Verifier si l'email existe deja
      const existingUser = await userRepository.findOne({
        where: { email: command.email },
      });

      if (existingUser) {
        throw new ConflictException('Email already exists');
      }

      // Hasher le mot de passe
      const hashedPassword = await bcrypt.hash(command.password, 10);

      // Creer l'utilisateur
      const user = userRepository.create({
        email: command.email,
        username: command.username,
        password: hashedPassword,
      });

      const savedUser = await userRepository.save(user);

      // Ne jamais retourner le mot de passe
      const { password, ...userWithoutPassword } = savedUser;

      this.logger.log(`User created: ${savedUser.email}`);
      return userWithoutPassword;
    } catch (error) {
      this.logger.error(`Error creating user: ${error.message}`, error.stack);
      throw error;
    }
  }
}
EOF

    # Login Command (impl)
    cat > "$PROJECT_DIR/src/auth/commands/impl/login.command/login.command.ts" << 'EOF'
/**
 * Login Command - Standard 41DEVS
 */
import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty } from 'class-validator';

export class LoginCommand {
  @ApiProperty({
    description: 'Email de l\'utilisateur',
    example: 'user@example.com',
  })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiProperty({
    description: 'Mot de passe',
    example: 'password123',
  })
  @IsNotEmpty()
  password: string;
}
EOF

    # Login Command Handler
    cat > "$PROJECT_DIR/src/auth/commands/handlers/login.command.handler/login.command.handler.ts" << 'EOF'
/**
 * Login Command Handler - Standard 41DEVS
 */
import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { LoginCommand } from '../../impl/login.command/login.command';
import { DataSource } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { Logger, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { UserModel } from '../../../models/user.model/user.model';

@CommandHandler(LoginCommand)
export class LoginCommandHandler implements ICommandHandler<LoginCommand> {
  private readonly logger = new Logger(LoginCommandHandler.name);

  constructor(
    private readonly dataSource: DataSource,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  async execute(command: LoginCommand): Promise<any> {
    try {
      // Recuperer l'utilisateur avec le mot de passe
      const user = await this.dataSource
        .getRepository(UserModel)
        .createQueryBuilder('user')
        .addSelect('user.password')
        .where('user.email = :email', { email: command.email })
        .getOne();

      if (!user) {
        throw new NotFoundException('User not found');
      }

      if (!user.password) {
        throw new UnauthorizedException('Invalid credentials');
      }

      // Verifier le mot de passe
      const isPasswordValid = await bcrypt.compare(command.password, user.password);

      if (!isPasswordValid) {
        throw new UnauthorizedException('Invalid credentials');
      }

      // Generer le token JWT
      const payload = { sub: user.id, email: user.email };
      const expiresIn = this.configService.get<string>('jwt.expireIn') || '7d';
      const token = this.jwtService.sign(payload, {
        expiresIn: expiresIn as any,
        secret: this.configService.get<string>('jwt.secret'),
      });

      const { password, ...userWithoutPassword } = user;

      this.logger.log(`User logged in: ${user.email}`);
      return { token, user: userWithoutPassword };
    } catch (error) {
      this.logger.error(`Login error: ${error.message}`, error.stack);
      throw error;
    }
  }
}
EOF

    # Auth Me Query (impl)
    cat > "$PROJECT_DIR/src/auth/queries/impl/auth-me.query/auth-me.query.ts" << 'EOF'
/**
 * Auth Me Query - Standard 41DEVS
 */
export class AuthMeQuery {
  userId: string;
}
EOF

    # Auth Me Handler
    cat > "$PROJECT_DIR/src/auth/queries/handlers/auth-me.handler/auth-me.handler.ts" << 'EOF'
/**
 * Auth Me Handler - Standard 41DEVS
 */
import { IQueryHandler, QueryHandler } from '@nestjs/cqrs';
import { AuthMeQuery } from '../../impl/auth-me.query/auth-me.query';
import { DataSource } from 'typeorm';
import { NotFoundException } from '@nestjs/common';
import { UserModel } from '../../../models/user.model/user.model';

@QueryHandler(AuthMeQuery)
export class AuthMeHandler implements IQueryHandler<AuthMeQuery> {
  constructor(private readonly dataSource: DataSource) {}

  async execute(query: AuthMeQuery): Promise<any> {
    const user = await this.dataSource.getRepository(UserModel).findOne({
      where: { id: query.userId },
      select: ['id', 'email', 'username', 'created_at', 'updated_at'],
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    return user;
  }
}
EOF

    # Auth Controller
    cat > "$PROJECT_DIR/src/auth/auth.controller.ts" << 'EOF'
/**
 * Auth Controller - Standard 41DEVS
 */
import { Body, Controller, Get, Post, Request, UseGuards } from '@nestjs/common';
import { CommandBus, QueryBus } from '@nestjs/cqrs';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CreateUserCommand } from './commands/impl/create-user.command/create-user.command';
import { LoginCommand } from './commands/impl/login.command/login.command';
import { JwtAuthGuard } from './strategie/jwt-auth.guard';
import { AuthMeQuery } from './queries/impl/auth-me.query/auth-me.query';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly commandBus: CommandBus,
    private readonly queryBus: QueryBus,
  ) {}

  @Post('register')
  @ApiOperation({ summary: 'Register a new user' })
  async register(@Body() command: CreateUserCommand) {
    return this.commandBus.execute(command);
  }

  @Post('login')
  @ApiOperation({ summary: 'Login user' })
  async login(@Body() command: LoginCommand) {
    return this.commandBus.execute(command);
  }

  @Get('me')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Get current user info' })
  async me(@Request() req) {
    const query = new AuthMeQuery();
    query.userId = req.user.id;
    return this.queryBus.execute(query);
  }
}
EOF

    # Auth Module
    cat > "$PROJECT_DIR/src/auth/auth.module.ts" << 'EOF'
/**
 * Auth Module - Standard 41DEVS
 */
import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { CqrsModule } from '@nestjs/cqrs';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtService } from '@nestjs/jwt';
import { UserModel } from './models/user.model/user.model';
import { JwtStrategy } from './strategie/jwt.strategy';
import { CreateUserCommandHandler } from './commands/handlers/create-user.command.handler/create-user.command.handler';
import { LoginCommandHandler } from './commands/handlers/login.command.handler/login.command.handler';
import { AuthMeHandler } from './queries/handlers/auth-me.handler/auth-me.handler';

@Module({
  imports: [
    CqrsModule,
    TypeOrmModule.forFeature([UserModel]),
  ],
  controllers: [AuthController],
  providers: [
    JwtService,
    JwtStrategy,
    CreateUserCommandHandler,
    LoginCommandHandler,
    AuthMeHandler,
  ],
  exports: [JwtStrategy],
})
export class AuthModule {}
EOF
}

# --- Creer le module User ---
create_user_module() {
    echo -e "${BLUE}👤 Creation du module User...${NC}"
    
    # Get All Query (impl)
    cat > "$PROJECT_DIR/src/user/queries/impl/get-all.query/get-all.query.ts" << 'EOF'
/**
 * Get All Users Query - Standard 41DEVS
 */
export class GetAllQuery {}
EOF

    # Get All Handler
    cat > "$PROJECT_DIR/src/user/queries/handlers/get-all.handler/get-all.handler.ts" << 'EOF'
/**
 * Get All Users Handler - Standard 41DEVS
 */
import { IQueryHandler, QueryHandler } from '@nestjs/cqrs';
import { GetAllQuery } from '../../impl/get-all.query/get-all.query';
import { DataSource } from 'typeorm';
import { UserModel } from '../../../../auth/models/user.model/user.model';

@QueryHandler(GetAllQuery)
export class GetAllHandler implements IQueryHandler<GetAllQuery> {
  constructor(private readonly dataSource: DataSource) {}

  async execute(query: GetAllQuery): Promise<any> {
    return this.dataSource.getRepository(UserModel).find({
      select: ['id', 'email', 'username', 'created_at', 'updated_at'],
    });
  }
}
EOF

    # Find By Id Query (impl)
    cat > "$PROJECT_DIR/src/user/queries/impl/find-by-id.query/find-by-id.query.ts" << 'EOF'
/**
 * Find User By Id Query - Standard 41DEVS
 */
import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsUUID } from 'class-validator';

export class FindByIdQuery {
  @ApiProperty({
    description: 'User ID (UUID)',
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  @IsNotEmpty()
  @IsUUID()
  id: string;
}
EOF

    # Find By Id Handler
    cat > "$PROJECT_DIR/src/user/queries/handlers/find-by-id.handler/find-by-id.handler.ts" << 'EOF'
/**
 * Find User By Id Handler - Standard 41DEVS
 */
import { IQueryHandler, QueryHandler } from '@nestjs/cqrs';
import { FindByIdQuery } from '../../impl/find-by-id.query/find-by-id.query';
import { DataSource } from 'typeorm';
import { NotFoundException } from '@nestjs/common';
import { UserModel } from '../../../../auth/models/user.model/user.model';

@QueryHandler(FindByIdQuery)
export class FindByIdHandler implements IQueryHandler<FindByIdQuery> {
  constructor(private readonly dataSource: DataSource) {}

  async execute(query: FindByIdQuery): Promise<any> {
    const user = await this.dataSource.getRepository(UserModel).findOne({
      where: { id: query.id },
      select: ['id', 'email', 'username', 'created_at', 'updated_at'],
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    return user;
  }
}
EOF

    # Update User Command (impl)
    cat > "$PROJECT_DIR/src/user/commands/impl/update-user.command/update-user.command.ts" << 'EOF'
/**
 * Update User Command - Standard 41DEVS
 */
import { ApiProperty } from '@nestjs/swagger';
import { IsOptional } from 'class-validator';

export class UpdateUserCommand {
  id: string; // Set from JWT token

  @ApiProperty({
    description: 'New username',
    required: false,
    example: 'new_username',
  })
  @IsOptional()
  username?: string;
}
EOF

    # Update User Command Handler
    cat > "$PROJECT_DIR/src/user/commands/handlers/update-user.command.handler/update-user.command.handler.ts" << 'EOF'
/**
 * Update User Command Handler - Standard 41DEVS
 */
import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { UpdateUserCommand } from '../../impl/update-user.command/update-user.command';
import { DataSource } from 'typeorm';
import { Logger, NotFoundException } from '@nestjs/common';
import { UserModel } from '../../../../auth/models/user.model/user.model';

@CommandHandler(UpdateUserCommand)
export class UpdateUserCommandHandler implements ICommandHandler<UpdateUserCommand> {
  private readonly logger = new Logger(UpdateUserCommandHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(command: UpdateUserCommand): Promise<any> {
    const userRepository = this.dataSource.getRepository(UserModel);

    const user = await userRepository.findOne({
      where: { id: command.id },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    if (command.username) {
      user.username = command.username;
    }

    const updatedUser = await userRepository.save(user);
    const { password, ...userWithoutPassword } = updatedUser;

    this.logger.log(`User updated: ${updatedUser.id}`);
    return userWithoutPassword;
  }
}
EOF

    # Delete User Command (impl)
    cat > "$PROJECT_DIR/src/user/commands/impl/delete-user.command/delete-user.command.ts" << 'EOF'
/**
 * Delete User Command - Standard 41DEVS
 */
export class DeleteUserCommand {
  id: string; // Set from JWT token
}
EOF

    # Delete User Command Handler
    cat > "$PROJECT_DIR/src/user/commands/handlers/delete-user.command.handler/delete-user.command.handler.ts" << 'EOF'
/**
 * Delete User Command Handler - Standard 41DEVS
 */
import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { DeleteUserCommand } from '../../impl/delete-user.command/delete-user.command';
import { DataSource } from 'typeorm';
import { Logger, NotFoundException } from '@nestjs/common';
import { UserModel } from '../../../../auth/models/user.model/user.model';

@CommandHandler(DeleteUserCommand)
export class DeleteUserCommandHandler implements ICommandHandler<DeleteUserCommand> {
  private readonly logger = new Logger(DeleteUserCommandHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(command: DeleteUserCommand): Promise<any> {
    const userRepository = this.dataSource.getRepository(UserModel);

    const user = await userRepository.findOne({
      where: { id: command.id },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    await userRepository.remove(user);

    this.logger.log(`User deleted: ${command.id}`);
    return { message: 'User deleted successfully' };
  }
}
EOF

    # User Controller
    cat > "$PROJECT_DIR/src/user/user.controller.ts" << 'EOF'
/**
 * User Controller - Standard 41DEVS
 */
import { Body, Controller, Delete, Get, Post, Query, Request, UseGuards } from '@nestjs/common';
import { CommandBus, QueryBus } from '@nestjs/cqrs';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { GetAllQuery } from './queries/impl/get-all.query/get-all.query';
import { FindByIdQuery } from './queries/impl/find-by-id.query/find-by-id.query';
import { UpdateUserCommand } from './commands/impl/update-user.command/update-user.command';
import { DeleteUserCommand } from './commands/impl/delete-user.command/delete-user.command';
import { JwtAuthGuard } from '../auth/strategie/jwt-auth.guard';

@ApiTags('Users')
@Controller('user')
export class UserController {
  constructor(
    private readonly commandBus: CommandBus,
    private readonly queryBus: QueryBus,
  ) {}

  @Get('all')
  @ApiOperation({ summary: 'Get all users' })
  async getAll(@Query() query: GetAllQuery) {
    return this.queryBus.execute(query);
  }

  @Get('by-id')
  @ApiOperation({ summary: 'Get user by ID' })
  async getById(@Query() query: FindByIdQuery) {
    return this.queryBus.execute(query);
  }

  @Post('update')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Update current user' })
  async update(@Body() command: UpdateUserCommand, @Request() req) {
    command.id = req.user.id;
    return this.commandBus.execute(command);
  }

  @Delete('delete')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Delete current user' })
  async delete(@Body() command: DeleteUserCommand, @Request() req) {
    command.id = req.user.id;
    return this.commandBus.execute(command);
  }
}
EOF

    # User Module
    cat > "$PROJECT_DIR/src/user/user.module.ts" << 'EOF'
/**
 * User Module - Standard 41DEVS
 */
import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { CqrsModule } from '@nestjs/cqrs';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserModel } from '../auth/models/user.model/user.model';
import { JwtStrategy } from '../auth/strategie/jwt.strategy';
import { GetAllHandler } from './queries/handlers/get-all.handler/get-all.handler';
import { FindByIdHandler } from './queries/handlers/find-by-id.handler/find-by-id.handler';
import { UpdateUserCommandHandler } from './commands/handlers/update-user.command.handler/update-user.command.handler';
import { DeleteUserCommandHandler } from './commands/handlers/delete-user.command.handler/delete-user.command.handler';

@Module({
  imports: [
    CqrsModule,
    TypeOrmModule.forFeature([UserModel]),
  ],
  controllers: [UserController],
  providers: [
    JwtStrategy,
    GetAllHandler,
    FindByIdHandler,
    UpdateUserCommandHandler,
    DeleteUserCommandHandler,
  ],
})
export class UserModule {}
EOF
}

# --- Creer le module Health ---
create_health_module() {
    echo -e "${BLUE}❤️ Creation du module Health...${NC}"
    
    # Get Health Query (impl)
    cat > "$PROJECT_DIR/src/health/queries/impl/get-health.query/get-health.query.ts" << 'EOF'
/**
 * Get Health Query - Standard 41DEVS
 */
export class GetHealthQuery {}
EOF

    # Get Health Handler
    cat > "$PROJECT_DIR/src/health/queries/handlers/get-health.handler/get-health.handler.ts" << 'EOF'
/**
 * Get Health Handler - Standard 41DEVS
 */
import { IQueryHandler, QueryHandler } from '@nestjs/cqrs';
import { GetHealthQuery } from '../../impl/get-health.query/get-health.query';

@QueryHandler(GetHealthQuery)
export class GetHealthHandler implements IQueryHandler<GetHealthQuery> {
  async execute(query: GetHealthQuery): Promise<any> {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      message: 'API NestJS CQRS - Standard 41DEVS',
    };
  }
}
EOF

    # Health Controller
    cat > "$PROJECT_DIR/src/health/health.controller.ts" << 'EOF'
/**
 * Health Controller - Standard 41DEVS
 */
import { Controller, Get } from '@nestjs/common';
import { QueryBus } from '@nestjs/cqrs';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { GetHealthQuery } from './queries/impl/get-health.query/get-health.query';

@ApiTags('Health')
@Controller('health')
export class HealthController {
  constructor(private readonly queryBus: QueryBus) {}

  @Get()
  @ApiOperation({ summary: 'Check API health status' })
  async getHealth() {
    return this.queryBus.execute(new GetHealthQuery());
  }
}
EOF

    # Health Module
    cat > "$PROJECT_DIR/src/health/health.module.ts" << 'EOF'
/**
 * Health Module - Standard 41DEVS
 */
import { Module } from '@nestjs/common';
import { CqrsModule } from '@nestjs/cqrs';
import { HealthController } from './health.controller';
import { GetHealthHandler } from './queries/handlers/get-health.handler/get-health.handler';

@Module({
  imports: [CqrsModule],
  controllers: [HealthController],
  providers: [GetHealthHandler],
})
export class HealthModule {}
EOF
}

# --- Creer le README ---
create_readme() {
    echo -e "${BLUE}📚 Creation du README.md...${NC}"
    
    cat > "$PROJECT_DIR/README.md" << 'EOF'
# NestJS CQRS API - Standard 41DEVS

> Projet genere par **Ibrahim** avec le script `setup-nestjs-cqrs.sh`

## 🚀 Quick Start

```bash
# Installer les dependances
npm install

# Configurer la base de donnees
# Editer src/config/default.yml

# Lancer en mode developpement
npm run start:dev
```

## 📁 Structure du projet

```
src/
├── config/
│   ├── default.yml          # Configuration YAML
│   └── configuration.ts     # Chargeur de config
├── auth/                     # Module Auth (register, login, me)
│   ├── commands/
│   │   ├── handlers/         # Logique metier
│   │   └── impl/             # Commandes (DTO + validation)
│   ├── queries/
│   │   ├── handlers/
│   │   └── impl/
│   ├── models/               # Entites TypeORM
│   ├── strategie/            # JWT Strategy + Guard
│   ├── auth.controller.ts
│   └── auth.module.ts
├── user/                     # Module User (CRUD)
│   └── ...
├── health/                   # Module Health (exemple)
│   └── ...
├── main.ts                   # Bootstrap
├── app.module.ts             # Module racine
├── app.controller.ts
├── app.service.ts
└── polyfill.ts               # Compatibilite crypto
```

## 🔐 Pattern CQRS 41DEVS

### Commands (Actions qui modifient l'etat)

```
commands/
├── handlers/
│   └── create-user.command.handler/
│       └── create-user.command.handler.ts   # Logique
└── impl/
    └── create-user.command/
        └── create-user.command.ts           # DTO + Validation
```

### Queries (Lecture seule)

```
queries/
├── handlers/
│   └── get-all.handler/
│       └── get-all.handler.ts               # Logique
└── impl/
    └── get-all.query/
        └── get-all.query.ts                 # DTO
```

## 🛠️ Scripts disponibles

| Commande | Description |
|----------|-------------|
| `npm run start:dev` | Developpement avec hot-reload |
| `npm run start:debug` | Debug mode |
| `npm run build` | Build production |
| `npm run start:prod` | Production |
| `npm run lint` | ESLint |
| `npm run test` | Tests Jest |
| `npm run db:setup` | Creer la base de donnees |
| `npm run db:drop` | Supprimer la base de donnees |
| `npm run db:reset` | Reset complet (drop + setup) |

## 🗄️ Base de donnees

### Premier demarrage

```bash
# 1. Creer la base de donnees PostgreSQL
npm run db:setup

# 2. Lancer l'application
npm run start:dev
```

### Reset complet (comme Laravel migrate:fresh)

```bash
npm run db:reset
npm run start:dev
```

## ⚙️ Configuration

Editer `src/config/default.yml`:

```yaml
database:
  host: localhost
  port: 5432
  username: root
  password: root
  database: my_project_name

jwt:
  secret: "CHANGE-ME-IN-PRODUCTION"
  expireIn: "7d"
```

## 🌐 URLs

| URL | Description |
|-----|-------------|
| http://localhost:3000 | API Root |
| http://localhost:3000/api | Swagger UI |
| http://localhost:3000/health | Health Check |

## 🔧 Creer un nouveau module

```bash
generate-module.sh products
```

## 📝 License

MIT - Created by Ibrahim for 41DEVS
EOF
}

# --- Creer les scripts de base de donnees ---
create_database_scripts() {
    echo -e "${BLUE}🗄️ Creation des scripts de base de donnees...${NC}"
    
    mkdir -p "$PROJECT_DIR/database"
    
    # setup-database.sql
    cat > "$PROJECT_DIR/database/setup-database.sql" << EOF
-- ============================================================
-- 🗄️ Script de creation de la base de donnees PostgreSQL
-- ============================================================
-- Executer avec: npm run db:setup
-- Ou: sudo -u postgres psql -f database/setup-database.sql
-- ============================================================

-- 1. Creer l'utilisateur root avec SUPERUSER (pour dev uniquement!)
DO \$\$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'root') THEN
        CREATE USER root WITH PASSWORD 'root' SUPERUSER CREATEDB;
    ELSE
        -- Si l'utilisateur existe deja, lui donner SUPERUSER
        ALTER USER root WITH SUPERUSER;
    END IF;
END
\$\$;

-- 2. Supprimer la base si elle existe
DROP DATABASE IF EXISTS $DB_NAME;

-- 3. Creer la base de donnees
CREATE DATABASE $DB_NAME OWNER root;

-- 4. Se connecter a la base $DB_NAME
\\c $DB_NAME

-- 5. Changer le proprietaire du schema public
ALTER SCHEMA public OWNER TO root;

-- ============================================================
-- ✅ Configuration terminee !
-- 🚀 Lancer: npm run start:dev
-- ============================================================
EOF

    # drop-database.sql
    cat > "$PROJECT_DIR/database/drop-database.sql" << EOF
-- ============================================================
-- 🗑️ Script de suppression de la base de donnees PostgreSQL
-- ============================================================
-- Executer avec: npm run db:drop
-- Ou: sudo -u postgres psql -f database/drop-database.sql
-- ⚠️  ATTENTION: Cette action est irreversible !
-- ============================================================

-- Fermer toutes les connexions actives a la base
SELECT
    pg_terminate_backend (pg_stat_activity.pid)
FROM
    pg_stat_activity
WHERE
    pg_stat_activity.datname = '$DB_NAME'
    AND pid <> pg_backend_pid ();

-- Supprimer la base de donnees
DROP DATABASE IF EXISTS $DB_NAME;

-- ============================================================
-- ✅ Base de donnees supprimee avec succes
-- 
-- 🔄 Pour recreer la base, executer:
--    npm run db:setup
-- ============================================================
EOF
}

# --- Creer les fichiers de test ---
create_test_files() {
    echo -e "${BLUE}🧪 Creation des fichiers de test...${NC}"
    
    cat > "$PROJECT_DIR/test/jest-e2e.json" << 'EOF'
{
  "moduleFileExtensions": ["js", "json", "ts"],
  "rootDir": ".",
  "testEnvironment": "node",
  "testRegex": ".e2e-spec.ts$",
  "transform": {
    "^.+\\.(t|j)s$": "ts-jest"
  }
}
EOF

    cat > "$PROJECT_DIR/test/app.e2e-spec.ts" << 'EOF'
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from './../src/app.module';

describe('AppController (e2e)', () => {
  let app: INestApplication;

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  it('/ (GET)', () => {
    return request(app.getHttpServer())
      .get('/')
      .expect(200)
      .expect('Welcome to NestJS CQRS API - Standard 41DEVS');
  });
});
EOF
}

# --- Installer les dependances ---
install_dependencies() {
    if [ "$SKIP_INSTALL" = true ]; then
        echo ""
        echo -e "${YELLOW}⏭️ Installation npm ignoree (--no-install)${NC}"
        echo -e "${YELLOW}   Executez 'npm install --legacy-peer-deps' manuellement${NC}"
    else
        echo ""
        echo -e "${BLUE}📦 Installation des dependances npm...${NC}"
        cd "$PROJECT_DIR"
        npm install --legacy-peer-deps
    fi
}

# --- Afficher le resume ---
show_summary() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          ✨ PROJET CREE AVEC SUCCES!                         ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "📁 Projet:    ${CYAN}$PROJECT_DIR${NC}"
    echo ""
    echo -e "${YELLOW}📦 Modules inclus:${NC}"
    echo "   - Auth (register, login, me)"
    echo "   - User (getAll, getById, update, delete)"
    echo "   - Health (health check)"
    echo ""
    echo -e "${YELLOW}🎯 Prochaines etapes:${NC}"
    echo ""
    echo -e "   ${CYAN}cd $PROJECT_NAME${NC}"
    
    if [ "$SKIP_INSTALL" = true ]; then
        echo -e "   ${CYAN}npm install${NC}"
    fi
    
    echo -e "   ${CYAN}# Editer src/config/default.yml${NC}"
    echo -e "   ${CYAN}npm run start:dev${NC}"
    echo ""
    echo -e "${YELLOW}🌐 URLs apres demarrage:${NC}"
    echo "   - Swagger: http://localhost:3000/api"
    echo "   - Health:  http://localhost:3000/health"
    echo ""
    echo -e "${YELLOW}📚 Creer un nouveau module:${NC}"
    echo -e "   ${CYAN}generate-module.sh products${NC}"
    echo ""
    echo -e "${GREEN}══════════════════════════════════════════════════════════════${NC}"
}

# ============================================================
# MAIN
# ============================================================

parse_args "$@"
setup_project_dir
show_header

create_package_json
create_ts_config
create_gitignore
create_directory_structure
create_config_files
create_src_root_files
create_auth_module
create_user_module
create_health_module
create_readme
create_database_scripts
create_test_files

install_dependencies
show_summary
