#!/bin/bash

# ============================================================
# 🚀 SCRIPT D'INSTALLATION NESTJS + CQRS (41DEVS Standard)
# ============================================================
# Usage: 
#   1. Créer d'abord le projet: nest new mon-projet
#   2. cd mon-projet
#   3. chmod +x setup-nestjs-cqrs.sh && ./setup-nestjs-cqrs.sh
# ============================================================

set -e  # Arrêter en cas d'erreur

echo "🚀 Installation des dépendances NestJS + CQRS..."
echo "================================================"

# ============================================================
# 📦 DÉPENDANCES DE PRODUCTION
# ============================================================

echo ""
echo "📦 Installation des dépendances de production..."

# --- Core NestJS ---
npm install @nestjs/common @nestjs/core @nestjs/platform-express

# --- CQRS (Command Query Responsibility Segregation) ---
npm install @nestjs/cqrs

# --- Base de données: TypeORM + PostgreSQL ---
npm install @nestjs/typeorm typeorm pg

# --- Configuration & Variables d'environnement ---
npm install @nestjs/config config
npm install dotenv

# --- Validation des DTOs ---
npm install class-validator class-transformer

# --- Mapped Types (pour PartialType, PickType, etc.) ---
npm install @nestjs/mapped-types

# --- Authentification JWT ---
npm install @nestjs/jwt @nestjs/passport passport passport-jwt
npm install bcrypt

# --- Documentation API Swagger ---
npm install @nestjs/swagger swagger-ui-express

# --- Logger Winston (Logging avancé) ---
npm install nest-winston winston

# --- Utilitaires ---
npm install uuid
npm install rxjs reflect-metadata

# --- Mappeur d'objets (optionnel mais utile) ---
npm install @automapper/core @automapper/classes @automapper/nestjs

echo "✅ Dépendances de production installées!"

# ============================================================
# 🛠️ DÉPENDANCES DE DÉVELOPPEMENT
# ============================================================

echo ""
echo "🛠️ Installation des dépendances de développement..."

# --- TypeScript & Types ---
npm install --save-dev typescript ts-node ts-loader
npm install --save-dev @types/node @types/express
npm install --save-dev @types/passport-jwt @types/bcrypt @types/uuid

# --- Tests: Jest ---
npm install --save-dev jest @types/jest ts-jest
npm install --save-dev @nestjs/testing supertest @types/supertest

# --- Linting: ESLint ---
npm install --save-dev eslint @eslint/js
npm install --save-dev @typescript-eslint/eslint-plugin @typescript-eslint/parser
npm install --save-dev eslint-config-prettier eslint-plugin-prettier

# --- Formatting: Prettier ---
npm install --save-dev prettier

# --- Hot Reload Dev Server ---
npm install --save-dev @nestjs/cli

# --- Source Maps pour debug ---
npm install --save-dev source-map-support

echo "✅ Dépendances de développement installées!"

# ============================================================
# 📁 CRÉATION DE LA STRUCTURE DE DOSSIERS 41DEVS
# ============================================================

echo ""
echo "📁 Création de la structure de dossiers 41DEVS..."

# Structure src/
mkdir -p src/config
mkdir -p src/common/decorators
mkdir -p src/common/guards
mkdir -p src/common/interceptors
mkdir -p src/common/filters
mkdir -p src/common/pipes
mkdir -p src/common/middlewares
mkdir -p src/common/interfaces
mkdir -p src/common/enums
mkdir -p src/common/utils
mkdir -p src/shared/email
mkdir -p src/shared/sms
mkdir -p src/shared/storage
mkdir -p src/shared/notification

# Config externe
mkdir -p config
mkdir -p settings

# Tests E2E
mkdir -p test

# Documentation
mkdir -p docs/adr

echo "✅ Structure de dossiers créée!"

# ============================================================
# 📄 CRÉATION DES FICHIERS DE CONFIGURATION DE BASE
# ============================================================

echo ""
echo "📄 Création des fichiers de configuration..."

# --- .env.example ---
cat > .env.example << 'EOF'
# Application
NODE_ENV=development
PORT=3000
API_PREFIX=api

# Base de données PostgreSQL
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=root
DATABASE_PASSWORD=root
DATABASE_NAME=cqrs_learning

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRATION=1d

# Logging
LOG_LEVEL=debug
EOF

# --- .env (copie de l'example) ---
cp .env.example .env

# --- config/default.json ---
cat > config/default.json << 'EOF'
{
  "app": {
    "name": "NestJS CQRS App",
    "port": 3000,
    "apiPrefix": "api"
  },
  "database": {
    "type": "postgres",
    "host": "localhost",
    "port": 5432,
    "username": "root",
    "password": "root",
    "database": "cqrs_learning",
    "synchronize": true,
    "logging": true
  },
  "jwt": {
    "secret": "your-super-secret-jwt-key",
    "expiresIn": "1d"
  }
}
EOF

# --- config/development.json ---
cat > config/development.json << 'EOF'
{
  "database": {
    "synchronize": true,
    "logging": true
  }
}
EOF

# --- config/production.json ---
cat > config/production.json << 'EOF'
{
  "database": {
    "synchronize": false,
    "logging": false
  }
}
EOF

# --- settings/typeorm.config.ts ---
cat > settings/typeorm.config.ts << 'EOF'
import { DataSource, DataSourceOptions } from 'typeorm';
import * as dotenv from 'dotenv';

dotenv.config();

export const dataSourceOptions: DataSourceOptions = {
  type: 'postgres',
  host: process.env.DATABASE_HOST || 'localhost',
  port: parseInt(process.env.DATABASE_PORT || '5432', 10),
  username: process.env.DATABASE_USER || 'root',
  password: process.env.DATABASE_PASSWORD || 'root',
  database: process.env.DATABASE_NAME || 'cqrs_learning',
  entities: ['dist/**/*.entity.js'],
  migrations: ['dist/migrations/*.js'],
  synchronize: process.env.NODE_ENV === 'development',
  logging: process.env.NODE_ENV === 'development',
};

const dataSource = new DataSource(dataSourceOptions);
export default dataSource;
EOF

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

echo "✅ Fichiers de configuration créés!"

# ============================================================
# ✨ RÉSUMÉ FINAL
# ============================================================

echo ""
echo "============================================================"
echo "✨ INSTALLATION TERMINÉE AVEC SUCCÈS!"
echo "============================================================"
echo ""
echo "📦 Dépendances installées:"
echo "   - NestJS Core + Platform Express"
echo "   - CQRS (@nestjs/cqrs)"
echo "   - TypeORM + PostgreSQL"
echo "   - Validation (class-validator, class-transformer)"
echo "   - JWT Auth (passport, bcrypt)"
echo "   - Swagger (documentation API)"
echo "   - Winston Logger"
echo "   - AutoMapper"
echo ""
echo "📁 Structure 41DEVS créée: src/common, src/config, src/shared..."
echo ""
echo "🎯 Prochaines étapes:"
echo "   1. Créer ta base de données PostgreSQL: cqrs_learning"
echo "   2. Vérifier/modifier le fichier .env"
echo "   3. Lancer le serveur: npm run start:dev"
echo ""
echo "============================================================"
