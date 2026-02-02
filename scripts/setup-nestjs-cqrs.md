# Setup NestJS CQRS - Documentation

## Description

Script d'installation automatique des dependances et de la structure de dossiers pour un projet NestJS suivant le pattern CQRS et les conventions 41DEVS.

## Emplacement

```
scripts/setup-nestjs-cqrs.sh
```

## Usage

```bash
# 1. Creer d'abord le projet NestJS
nest new mon-projet
cd mon-projet

# 2. Copier le script dans le projet ou l'executer depuis le chemin
../scripts/setup-nestjs-cqrs.sh
```

## Ce que le script installe

### Dependances de Production

| Package | Description |
|---------|-------------|
| `@nestjs/common`, `@nestjs/core` | Core NestJS |
| `@nestjs/cqrs` | Module CQRS |
| `@nestjs/typeorm`, `typeorm`, `pg` | ORM + PostgreSQL |
| `@nestjs/config`, `dotenv` | Configuration |
| `class-validator`, `class-transformer` | Validation DTOs |
| `@nestjs/mapped-types` | PartialType, PickType |
| `@nestjs/jwt`, `@nestjs/passport`, `passport-jwt` | Authentification |
| `bcrypt` | Hashage mots de passe |
| `@nestjs/swagger` | Documentation API |
| `nest-winston`, `winston` | Logging avance |
| `@automapper/*` | Mapping objets |

### Dependances de Developpement

| Package | Description |
|---------|-------------|
| `typescript`, `ts-node` | TypeScript |
| `@types/*` | Types TypeScript |
| `jest`, `@nestjs/testing` | Tests |
| `eslint`, `prettier` | Linting et formatting |

### Structure de Dossiers Creee

```
src/
├── config/              # Configuration applicative
├── common/
│   ├── decorators/      # Decorateurs personnalises
│   ├── guards/          # Guards d'authentification
│   ├── interceptors/    # Intercepteurs
│   ├── filters/         # Filtres d'exceptions
│   ├── pipes/           # Pipes de validation
│   ├── middlewares/     # Middlewares
│   ├── interfaces/      # Interfaces partagees
│   ├── enums/           # Enumerations
│   └── utils/           # Utilitaires
├── shared/
│   ├── email/           # Service email
│   ├── sms/             # Service SMS
│   ├── storage/         # Service stockage
│   └── notification/    # Notifications
config/
├── default.json         # Config par defaut
├── development.json     # Config developpement
└── production.json      # Config production
settings/
└── typeorm.config.ts    # Config TypeORM pour migrations
docs/
└── adr/                 # Architecture Decision Records
```

### Fichiers de Configuration Crees

| Fichier | Description |
|---------|-------------|
| `.env.example` | Template des variables d'environnement |
| `.env` | Variables d'environnement (copie de example) |
| `config/default.json` | Configuration par defaut |
| `config/development.json` | Configuration dev |
| `config/production.json` | Configuration prod |
| `settings/typeorm.config.ts` | Configuration TypeORM |
| `.prettierrc` | Configuration Prettier |

## Variables d'Environnement

```env
# Application
NODE_ENV=development
PORT=3000
API_PREFIX=api

# Base de donnees PostgreSQL
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=root
DATABASE_PASSWORD=root
DATABASE_NAME=cqrs_learning

# JWT
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRATION=1d

# Logging
LOG_LEVEL=debug
```

## Apres l'Installation

1. **Creer la base de donnees** PostgreSQL
2. **Verifier le fichier `.env`** et ajuster si necessaire
3. **Lancer le serveur** : `npm run start:dev`

## Compatibilite

- Linux (Ubuntu, Debian, etc.)
- macOS
- Windows (Git Bash, WSL)

## Version

1.0.0
