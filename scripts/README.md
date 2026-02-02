# Scripts 41DEVS - NestJS CQRS

Ensemble de scripts pour automatiser la creation et la gestion de projets NestJS suivant le pattern CQRS.

## Installation Globale

Les scripts sont configures pour etre accessibles depuis n'importe quel dossier.
Voir [INSTALLATION.md](./INSTALLATION.md) pour les details.

```bash
# Usage depuis n'importe ou
generate-module.sh products
setup-nestjs-cqrs.sh
```

## Contenu

| Script | Description | Documentation |
|--------|-------------|---------------|
| `setup-nestjs-cqrs.sh` | Installation des dependances NestJS + CQRS | [setup-nestjs-cqrs.md](./setup-nestjs-cqrs.md) |
| `generate-module.sh` | Generateur de modules CQRS | [generate-module.md](./generate-module.md) |


## Documentation Base de Donnees

| Script | Description |
|--------|-------------|
| `setup-database.sql` | Creation de la base de donnees |
| `drop-database.sql` | Suppression de la base de donnees |

Voir [database.md](./database.md) pour plus de details.

## Installation Rapide

### 1. Creer un nouveau projet NestJS

```bash
nest new mon-projet
cd mon-projet
```

### 2. Installer les dependances CQRS

```bash
../scripts/setup-nestjs-cqrs.sh
```

### 3. Configurer la base de donnees

```bash
sudo -u postgres psql -f setup-database.sql
```

### 4. Generer un module

```bash
../scripts/generate-module.sh products
```

### 5. Importer le module

Ajouter dans `app.module.ts` :

```typescript
import { ProductsModule } from './products/products.module';

@Module({
  imports: [
    // ... autres imports
    ProductsModule,
  ],
})
export class AppModule {}
```

### 6. Lancer le serveur

```bash
npm run start:dev
```

## Structure d'un Module Genere

```
src/<module>/
├── <module>.module.ts
├── <module>.controller.ts
├── dto/
│   ├── create-<entity>.dto.ts
│   └── update-<entity>.dto.ts
├── models/
│   └── <entity>.entity.ts
├── commands/
│   ├── create-<entity>.command.ts
│   ├── create-<entity>.command.handler.ts
│   ├── update-<entity>.command.ts
│   ├── update-<entity>.command.handler.ts
│   ├── delete-<entity>.command.ts
│   └── delete-<entity>.command.handler.ts
└── queries/
    ├── get-<entities>.query.ts
    ├── get-<entities>.query.handler.ts
    ├── get-<entity>-by-id.query.ts
    └── get-<entity>-by-id.query.handler.ts
```

## Endpoints API Generes

| Methode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/<module>` | Liste tous les elements |
| GET | `/<module>/:id` | Recupere un element par ID |
| POST | `/<module>` | Cree un nouvel element |
| PATCH | `/<module>/:id` | Met a jour un element |
| DELETE | `/<module>/:id` | Supprime un element (soft delete) |

## Compatibilite

- Linux (Ubuntu, Debian, CentOS, etc.)
- macOS
- Windows (Git Bash, WSL)

## Auteur

41DEVS

## Version

1.1.0
