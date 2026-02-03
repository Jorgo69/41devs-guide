# setup-nestjs-cqrs.sh - Documentation

## 🚀 Description

Script d'initialisation de projets NestJS avec le pattern CQRS selon le **Standard 41DEVS**.

Cree par **Ibrahim** pour l'equipe 41DEVS.

## 📦 Installation

```bash
# Ajouter les scripts au PATH (une seule fois)
cd scripts
bash install.sh
source ~/.bashrc
```

## 🎯 Usage

```bash
# Creer un nouveau projet avec installation npm
setup-nestjs-cqrs.sh mon-api

# Creer sans installer les dependances (rapide/offline)
setup-nestjs-cqrs.sh mon-api --no-install
setup-nestjs-cqrs.sh mon-api -n

# Initialiser dans le dossier actuel
setup-nestjs-cqrs.sh .

# Mode interactif
setup-nestjs-cqrs.sh

# Aide
setup-nestjs-cqrs.sh --help
```

## 📁 Structure generee

```
mon-api/
├── src/
│   ├── config/
│   │   ├── default.yml           # Configuration YAML
│   │   └── configuration.ts      # Chargeur de config
│   ├── auth/                      # Module Auth complet
│   │   ├── auth.controller.ts
│   │   ├── auth.module.ts
│   │   ├── commands/
│   │   │   ├── handlers/          # Logique metier
│   │   │   │   ├── create-user.command.handler/
│   │   │   │   └── login.command.handler/
│   │   │   └── impl/              # Commands (DTO + validation)
│   │   │       ├── create-user.command/
│   │   │       └── login.command/
│   │   ├── queries/
│   │   │   ├── handlers/
│   │   │   └── impl/
│   │   ├── models/
│   │   │   └── user.model/
│   │   └── strategie/
│   │       ├── jwt.strategy.ts
│   │       └── jwt-auth.guard.ts
│   ├── user/                      # Module User CRUD
│   │   └── ...
│   ├── health/                    # Module Health (exemple)
│   │   └── ...
│   ├── main.ts
│   ├── app.module.ts
│   ├── app.controller.ts
│   ├── app.service.ts
│   └── polyfill.ts
├── test/
├── .gitignore
├── .prettierrc
├── .eslintrc.js
├── nest-cli.json
├── tsconfig.json
├── tsconfig.build.json
├── package.json
└── README.md
```

## 🔐 Pattern CQRS 41DEVS

### Commands (modifient l'etat)

```
commands/
├── handlers/
│   └── create-user.command.handler/
│       └── create-user.command.handler.ts   # Logique
└── impl/
    └── create-user.command/
        └── create-user.command.ts           # DTO + Validation + Swagger
```

### Queries (lecture seule)

```
queries/
├── handlers/
│   └── get-all.handler/
│       └── get-all.handler.ts               # Logique
└── impl/
    └── get-all.query/
        └── get-all.query.ts                 # DTO
```

## ⚙️ Configuration

Le fichier `src/config/default.yml` remplace `.env`:

```yaml
database:
  type: postgres
  host: localhost
  port: 5432
  username: postgres
  password: postgres
  database: my_database
  synchronize: true

jwt:
  secret: "CHANGE-ME-IN-PRODUCTION"
  expireIn: "7d"

server:
  port: 3000
```

## 📦 Dependances

### Production
- @nestjs/common, core, platform-express
- @nestjs/cqrs
- @nestjs/typeorm, typeorm, pg
- @nestjs/config, js-yaml
- @nestjs/jwt, @nestjs/passport, passport, passport-jwt, bcrypt
- @nestjs/swagger
- class-validator, class-transformer
- rxjs, reflect-metadata

### Dev
- @nestjs/cli, schematics, testing
- typescript, ts-node, ts-loader
- jest, ts-jest, supertest
- eslint, prettier
- @types/*

## 🌐 URLs

| URL | Description |
|-----|-------------|
| http://localhost:3000 | API Root |
| http://localhost:3000/api | Swagger UI |
| http://localhost:3000/health | Health Check |

## 🔧 Apres creation

```bash
cd mon-api

# Si --no-install a ete utilise
npm install

# Configurer la base de donnees
vim src/config/default.yml

# Lancer
npm run start:dev
```

## 📝 Creer un nouveau module

```bash
generate-module.sh products
```

Voir [generate-module.md](generate-module.md)
