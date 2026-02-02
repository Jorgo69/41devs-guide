# setup-nestjs-cqrs.sh

Script d'installation automatique pour projets NestJS avec CQRS (41DEVS Standard).

## Usage

```bash
# Creer un nouveau projet dans un dossier
setup-nestjs-cqrs.sh mon-api

# Initialiser dans le dossier actuel
setup-nestjs-cqrs.sh .

# Mode interactif (demande le nom)
setup-nestjs-cqrs.sh

# Afficher l'aide
setup-nestjs-cqrs.sh --help
```

## Structure generee

```
mon-api/
├── src/
│   ├── main.ts                # Point d'entree avec Swagger
│   ├── app.module.ts          # Module racine
│   ├── app.controller.ts      # Controller de base
│   ├── app.service.ts         # Service de base
│   ├── app.controller.spec.ts # Test unitaire
│   ├── config/
│   ├── common/
│   │   ├── decorators/
│   │   ├── guards/
│   │   ├── interceptors/
│   │   ├── filters/
│   │   ├── pipes/
│   │   ├── middlewares/
│   │   ├── interfaces/
│   │   ├── enums/
│   │   └── utils/
│   ├── shared/
│   │   ├── email/
│   │   ├── sms/
│   │   ├── storage/
│   │   └── notification/
│   └── health/                # Module exemple CQRS
│       ├── health.module.ts
│       ├── health.controller.ts
│       └── queries/
│           ├── get-health.query.ts
│           └── get-health.query.handler.ts
├── config/
├── settings/
├── test/
├── docs/adr/
├── http/
├── .env
├── .env.example
├── .gitignore
├── .prettierrc
├── tsconfig.json
└── nest-cli.json
```

## Dependances installees

### Production
| Package | Description |
|---------|-------------|
| @nestjs/common, core, platform-express | Core NestJS |
| @nestjs/cqrs | Pattern CQRS |
| @nestjs/typeorm, typeorm, pg | PostgreSQL |
| @nestjs/config, dotenv | Configuration |
| class-validator, class-transformer | Validation DTOs |
| @nestjs/jwt, passport, bcrypt | Authentification |
| @nestjs/swagger, swagger-ui-express | Documentation API |
| nest-winston, winston | Logging |
| uuid, rxjs, reflect-metadata | Utilitaires |

### Developpement
| Package | Description |
|---------|-------------|
| typescript, ts-node | TypeScript |
| jest, ts-jest | Tests |
| eslint, prettier | Linting/Formatting |
| @nestjs/cli | CLI NestJS |

## Fichiers configures

- **`.env`** : Variables PostgreSQL, JWT, etc.
- **`tsconfig.json`** : Optimise pour NestJS
- **`nest-cli.json`** : Configuration CLI
- **`.prettierrc`** : Regles 41DEVS
- **`.gitignore`** : Ignore node_modules, dist, .env

## Module exemple: Health

Le script cree un module `health` qui demontre le pattern CQRS :

```typescript
// GET /api/health
{
  "status": "ok",
  "timestamp": "2026-02-02T18:00:00.000Z",
  "uptime": 123.456,
  "message": "API NestJS CQRS - 41DEVS Standard"
}
```

## Apres l'installation

```bash
cd mon-api
vim .env                  # Configurer la base de donnees
npm run start:dev         # Lancer le serveur
```

## URLs

| URL | Description |
|-----|-------------|
| http://localhost:3000/api | Base API |
| http://localhost:3000/api/docs | Swagger UI |
| http://localhost:3000/api/health | Health check |

## Scripts npm

```bash
npm run start:dev    # Dev avec hot reload
npm run start:debug  # Debug mode
npm run start:prod   # Production
npm run build        # Build
npm run lint         # ESLint
npm run test         # Tests Jest
npm run test:cov     # Coverage
```
