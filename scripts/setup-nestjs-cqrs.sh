#!/bin/bash

# ============================================================
# 🚀 SCRIPT D'INSTALLATION NESTJS + CQRS (41DEVS Standard)
# ============================================================
# Usage:
#   setup-nestjs-cqrs.sh nom-projet    # Cree le dossier et installe dedans
#   setup-nestjs-cqrs.sh .             # Installe dans le dossier actuel
#   setup-nestjs-cqrs.sh               # Demande le nom du projet
#   setup-nestjs-cqrs.sh -h            # Affiche l'aide
# ============================================================

set -e

# --- Couleurs ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Afficher l'aide ---
show_help() {
    echo "Usage: setup-nestjs-cqrs.sh [nom-projet|.] [options]"
    echo ""
    echo "Initialise un projet NestJS avec CQRS (41DEVS Standard)."
    echo ""
    echo "Arguments:"
    echo "  nom-projet    Nom du dossier a creer pour le projet"
    echo "  .             Initialise dans le dossier actuel"
    echo "  (vide)        Demande le nom du projet de maniere interactive"
    echo ""
    echo "Options:"
    echo "  -h, --help    Affiche cette aide"
    echo ""
    echo "Exemples:"
    echo "  setup-nestjs-cqrs.sh mon-api"
    echo "  setup-nestjs-cqrs.sh ."
    echo "  setup-nestjs-cqrs.sh"
}

# --- Verifier l'aide ---
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# --- Determiner le dossier du projet ---
PROJECT_DIR=""
PROJECT_NAME=""

if [[ -n "$1" ]]; then
    if [[ "$1" == "." ]]; then
        # Utiliser le dossier actuel
        PROJECT_DIR="$(pwd)"
        PROJECT_NAME="$(basename "$PROJECT_DIR")"
        echo -e "${BLUE}📁 Installation dans le dossier actuel: $PROJECT_DIR${NC}"
    else
        # Creer un nouveau dossier
        PROJECT_NAME="$1"
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
    echo -e "${YELLOW}📝 Aucun nom de projet specifie.${NC}"
    read -p "Nom du projet (defaut: my-nest-app): " input_name
    PROJECT_NAME="${input_name:-my-nest-app}"
    PROJECT_DIR="$(pwd)/$PROJECT_NAME"
    
    if [[ -d "$PROJECT_DIR" ]]; then
        echo -e "${RED}❌ Erreur: Le dossier '$PROJECT_NAME' existe deja.${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}📁 Creation du dossier: $PROJECT_DIR${NC}"
    mkdir -p "$PROJECT_DIR"
fi

# --- Aller dans le dossier du projet ---
cd "$PROJECT_DIR"

echo ""
echo -e "${GREEN}🚀 Installation des dependances NestJS + CQRS...${NC}"
echo "================================================"
echo "Projet: $PROJECT_NAME"
echo "Dossier: $PROJECT_DIR"
echo "================================================"

# --- Initialiser package.json si necessaire ---
if [[ ! -f "package.json" ]]; then
    echo ""
    echo -e "${BLUE}📦 Initialisation du package.json...${NC}"
    npm init -y > /dev/null
    
    # Mettre a jour le nom du package
    sed -i "s/\"name\": \".*\"/\"name\": \"$PROJECT_NAME\"/" package.json
fi

# ============================================================
# 📦 DEPENDANCES DE PRODUCTION
# ============================================================

echo ""
echo -e "${BLUE}📦 Installation des dependances de production...${NC}"

# --- Core NestJS ---
npm install @nestjs/common @nestjs/core @nestjs/platform-express

# --- CQRS ---
npm install @nestjs/cqrs

# --- Base de donnees: TypeORM + PostgreSQL ---
npm install @nestjs/typeorm typeorm pg

# --- Configuration ---
npm install @nestjs/config dotenv

# --- Validation ---
npm install class-validator class-transformer

# --- Mapped Types ---
npm install @nestjs/mapped-types

# --- Authentification JWT ---
npm install @nestjs/jwt @nestjs/passport passport passport-jwt bcrypt

# --- Documentation API Swagger ---
npm install @nestjs/swagger swagger-ui-express

# --- Logger Winston ---
npm install nest-winston winston

# --- Utilitaires ---
npm install uuid rxjs reflect-metadata@0.1.14

echo -e "${GREEN}✅ Dependances de production installees!${NC}"

# ============================================================
# 🛠️ DEPENDANCES DE DEVELOPPEMENT
# ============================================================

echo ""
echo -e "${BLUE}🛠️ Installation des dependances de developpement...${NC}"

# --- TypeScript & Types ---
npm install --save-dev typescript ts-node ts-loader
npm install --save-dev @types/node @types/express
npm install --save-dev @types/passport-jwt @types/bcrypt @types/uuid

# --- Tests: Jest ---
npm install --save-dev jest @types/jest ts-jest
npm install --save-dev @nestjs/testing supertest @types/supertest

# --- Linting: ESLint ---
npm install --save-dev eslint @typescript-eslint/eslint-plugin @typescript-eslint/parser
npm install --save-dev eslint-config-prettier eslint-plugin-prettier

# --- Formatting: Prettier ---
npm install --save-dev prettier

# --- NestJS CLI ---
npm install --save-dev @nestjs/cli

echo -e "${GREEN}✅ Dependances de developpement installees!${NC}"

# ============================================================
# 📁 CREATION DE LA STRUCTURE 41DEVS
# ============================================================

echo ""
echo -e "${BLUE}📁 Creation de la structure de dossiers 41DEVS...${NC}"

# Structure src/
mkdir -p src/config
mkdir -p src/common/{decorators,guards,interceptors,filters,pipes,middlewares,interfaces,enums,utils}
mkdir -p src/shared/{email,sms,storage,notification}
mkdir -p config
mkdir -p settings
mkdir -p test
mkdir -p docs/adr
mkdir -p http

echo -e "${GREEN}✅ Structure de dossiers creee!${NC}"

# ============================================================
# 📄 FICHIERS DE CONFIGURATION
# ============================================================

echo ""
echo -e "${BLUE}📄 Creation des fichiers de configuration...${NC}"

# --- .env.example ---
cat > .env.example << 'EOF'
# Application
NODE_ENV=development
PORT=3000
API_PREFIX=api

# Base de donnees PostgreSQL
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=root
DATABASE_PASSWORD=root
DATABASE_NAME=my_database

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRATION=1d

# Logging
LOG_LEVEL=debug
EOF

# --- .env ---
cp .env.example .env

# --- .prettierrc ---
cat > .prettierrc << 'EOF'
{
  "singleQuote": true,
  "trailingComma": "all",
  "printWidth": 100,
  "tabWidth": 2,
  "semi": true
}
EOF

# --- .gitignore ---
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
**/node_modules/

# Build
dist/
**/dist/
build/

# Environment
.env
.env.local
.env.*.local
*.env

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
logs/
*.log

# Coverage
coverage/

# Temp
tmp/
temp/
*.tmp
EOF

# --- tsconfig.json ---
cat > tsconfig.json << 'EOF'
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

# --- nest-cli.json ---
cat > nest-cli.json << 'EOF'
{
  "$schema": "https://json.schemastore.org/nest-cli",
  "collection": "@nestjs/schematics",
  "sourceRoot": "src",
  "compilerOptions": {
    "deleteOutDir": true
  }
}
EOF

# --- Mettre a jour package.json avec les scripts ---
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
pkg.scripts = {
  ...pkg.scripts,
  'build': 'nest build',
  'start': 'nest start',
  'start:dev': 'nest start --watch',
  'start:debug': 'nest start --debug --watch',
  'start:prod': 'node dist/main',
  'lint': 'eslint \"{src,apps,libs}/**/*.ts\" --fix',
  'test': 'jest',
  'test:watch': 'jest --watch',
  'test:cov': 'jest --coverage',
  'test:e2e': 'jest --config ./test/jest-e2e.json'
};
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
"

# --- src/main.ts ---
cat > src/main.ts << 'EOF'
import { NestFactory } from '@nestjs/core';
import { ValidationPipe, Logger } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const logger = new Logger('Bootstrap');

  // Validation globale
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // Prefix API
  app.setGlobalPrefix('api');

  // Swagger
  const config = new DocumentBuilder()
    .setTitle('API Documentation')
    .setDescription('API NestJS CQRS - 41DEVS Standard')
    .setVersion('1.0')
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  const port = process.env.PORT || 3000;
  await app.listen(port);

  logger.log(`Application running on: http://localhost:${port}`);
  logger.log(`API Base URL: http://localhost:${port}/api`);
  logger.log(`Swagger Docs: http://localhost:${port}/api/docs`);
}
bootstrap();
EOF

# --- src/app.module.ts ---
cat > src/app.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CqrsModule } from '@nestjs/cqrs';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { HealthModule } from './health/health.module';

@Module({
  imports: [
    // Configuration
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),

    // Base de donnees
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DATABASE_HOST || 'localhost',
      port: parseInt(process.env.DATABASE_PORT || '5432', 10),
      username: process.env.DATABASE_USER || 'root',
      password: process.env.DATABASE_PASSWORD || 'root',
      database: process.env.DATABASE_NAME || 'my_database',
      autoLoadEntities: true,
      synchronize: process.env.NODE_ENV === 'development',
    }),

    // CQRS
    CqrsModule,

    // Modules
    HealthModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
EOF

# --- src/app.controller.ts ---
cat > src/app.controller.ts << 'EOF'
import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { AppService } from './app.service';

@ApiTags('app')
@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  @ApiOperation({ summary: 'Message de bienvenue' })
  getHello(): string {
    return this.appService.getHello();
  }
}
EOF

# --- src/app.service.ts ---
cat > src/app.service.ts << 'EOF'
import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Welcome to NestJS CQRS API - 41DEVS Standard';
  }
}
EOF

# --- src/app.controller.spec.ts ---
cat > src/app.controller.spec.ts << 'EOF'
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
      expect(appController.getHello()).toBe('Welcome to NestJS CQRS API - 41DEVS Standard');
    });
  });
});
EOF

# ============================================================
# 📦 MODULE EXEMPLE: HEALTH (Pattern CQRS)
# ============================================================

echo ""
echo -e "${BLUE}📦 Creation du module exemple 'health'...${NC}"

mkdir -p src/health/queries

# --- src/health/health.module.ts ---
cat > src/health/health.module.ts << 'EOF'
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
EOF

# --- src/health/health.controller.ts ---
cat > src/health/health.controller.ts << 'EOF'
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
EOF

# --- src/health/queries/get-health.query.ts ---
cat > src/health/queries/get-health.query.ts << 'EOF'
export class GetHealthQuery {}
EOF

# --- src/health/queries/get-health.query.handler.ts ---
cat > src/health/queries/get-health.query.handler.ts << 'EOF'
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
EOF

echo -e "${GREEN}✅ Module 'health' cree!${NC}"

echo -e "${GREEN}✅ Fichiers de configuration crees!${NC}"

# ============================================================
# ✨ RESUME FINAL
# ============================================================

echo ""
echo "============================================================"
echo -e "${GREEN}✨ INSTALLATION TERMINEE AVEC SUCCES!${NC}"
echo "============================================================"
echo ""
echo "📦 Dependances installees:"
echo "   - NestJS Core + Platform Express"
echo "   - CQRS (@nestjs/cqrs)"
echo "   - TypeORM + PostgreSQL"
echo "   - Validation (class-validator, class-transformer)"
echo "   - JWT Auth (passport, bcrypt)"
echo "   - Swagger (documentation API)"
echo "   - Winston Logger"
echo ""
echo "📁 Structure 41DEVS creee dans: $PROJECT_DIR"
echo ""
echo "📂 Fichiers src/ :"
echo "   - main.ts"
echo "   - app.module.ts"
echo "   - app.controller.ts"
echo "   - app.service.ts"
echo "   - app.controller.spec.ts"
echo "   - health/ (module exemple CQRS)"
echo ""
echo "🎯 Prochaines etapes:"
echo "   1. cd $PROJECT_NAME"
echo "   2. Creer ta base de donnees PostgreSQL"
echo "   3. Modifier le fichier .env avec tes parametres"
echo "   4. npm run start:dev"
echo ""
echo "🌐 URLs apres demarrage:"
echo "   - API: http://localhost:3000/api"
echo "   - Swagger: http://localhost:3000/api/docs"
echo "   - Health: http://localhost:3000/api/health"
echo ""
echo "============================================================"

