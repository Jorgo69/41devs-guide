# Generate Module - Documentation

## Description

Script de generation automatique de modules NestJS suivant le pattern CQRS et les conventions 41DEVS.

## Emplacement

```
scripts/generate-module.sh
```

## Usage

```bash
# Depuis le repertoire de votre projet NestJS
../scripts/generate-module.sh <nom-module> [options]

# Ou depuis n'importe ou avec le chemin complet
/chemin/vers/scripts/generate-module.sh <nom-module> [options]
```

## Arguments

| Argument | Description | Exemple |
|----------|-------------|---------|
| `nom-module` | Nom du module en kebab-case | `products`, `user-profiles` |

## Options

| Option | Description |
|--------|-------------|
| `--dry-run` | Affiche les fichiers qui seraient crees sans les creer |
| `--no-queries` | Ne genere pas les fichiers de queries (GET) |
| `--no-commands` | Ne genere pas les fichiers de commands (POST/PATCH/DELETE) |
| `--force` | Ecrase le module s'il existe deja |
| `-h, --help` | Affiche l'aide |

## Exemples

```bash
# Generer un module complet
./generate-module.sh products

# Voir ce qui serait cree sans rien creer
./generate-module.sh products --dry-run

# Generer un module sans les queries (lecture seule)
./generate-module.sh products --no-queries

# Ecraser un module existant
./generate-module.sh products --force
```

## Structure Generee

```
src/<module>/
├── <module>.module.ts           # Module NestJS
├── <module>.controller.ts       # Controller REST
├── dto/
│   ├── create-<entity>.dto.ts   # DTO de creation
│   └── update-<entity>.dto.ts   # DTO de mise a jour
├── models/
│   └── <entity>.entity.ts       # Entity TypeORM
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

## Conventions de Nommage

Le script convertit automatiquement les noms :

| Entree | Transformation | Resultat |
|--------|---------------|----------|
| `products` | Pluriel kebab-case | `products` |
| `products` | Singulier kebab-case | `product` |
| `products` | Pluriel PascalCase | `Products` |
| `products` | Singulier PascalCase | `Product` |
| `user-profiles` | Singulier PascalCase | `UserProfile` |

## Apres la Generation

1. **Importer le module** dans `app.module.ts` :

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

2. **Personnaliser l'entity** selon vos besoins (ajouter des champs)

3. **Tester l'API** avec les endpoints generes :
   - `GET /<module>` - Liste tous les elements
   - `GET /<module>/:id` - Recupere un element
   - `POST /<module>` - Cree un element
   - `PATCH /<module>/:id` - Met a jour un element
   - `DELETE /<module>/:id` - Supprime un element (soft delete)

## Compatibilite

- Linux (Ubuntu, Debian, etc.)
- macOS
- Windows (Git Bash, WSL)

## Version

1.1.0
