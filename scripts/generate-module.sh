#!/bin/bash
# ==============================================================================
# GENERATE-MODULE.SH - Generateur de Module CQRS pour NestJS (Standard 41DEVS)
# ==============================================================================
# Description:
#   Ce script genere automatiquement la structure complete d'un module NestJS
#   suivant le pattern CQRS (Command Query Responsibility Segregation) et les
#   conventions de nommage 41DEVS.
#
# Usage:
#   ./generate-module.sh <nom-module> [options]
#
# Exemples:
#   ./generate-module.sh products
#   ./generate-module.sh users --no-queries
#   ./generate-module.sh orders --dry-run
#
# Auteur: 41DEVS
# Version: 1.1.0
# Compatibilite: Linux, macOS, Windows (Git Bash/WSL)
# ==============================================================================

set -e  # Arreter le script en cas d'erreur

# ==============================================================================
# CONFIGURATION
# ==============================================================================

# Repertoire racine du projet (ou le script est execute)
PROJECT_ROOT="$(pwd)"
SRC_DIR="${PROJECT_ROOT}/src"

# Couleurs pour les messages (compatible POSIX)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ==============================================================================
# FONCTIONS UTILITAIRES
# ==============================================================================

# Affiche un message d'erreur et quitte
error() {
    printf "${RED}[ERREUR]${NC} %s\n" "$1" >&2
    exit 1
}

# Affiche un message de succes
success() {
    printf "${GREEN}[OK]${NC} %s\n" "$1"
}

# Affiche un message d'info
info() {
    printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

# Affiche un warning
warn() {
    printf "${YELLOW}[ATTENTION]${NC} %s\n" "$1"
}

# Convertit une chaine en PascalCase
# Exemple: "user-profile" -> "UserProfile"
to_pascal_case() {
    echo "$1" | sed -r 's/(^|[-_])([a-z])/\U\2/g'
}

# Convertit une chaine en camelCase
# Exemple: "user-profile" -> "userProfile"
to_camel_case() {
    local pascal=$(to_pascal_case "$1")
    echo "$(echo "${pascal:0:1}" | tr '[:upper:]' '[:lower:]')${pascal:1}"
}

# Obtient le singulier d'un mot (simpliste: enleve le 's' final)
# Pour une vraie gestion du pluriel, utiliser une lib externe
to_singular() {
    local word="$1"
    # Cas speciaux
    case "$word" in
        *ies) echo "${word%ies}y" ;;
        *es)  echo "${word%es}" ;;
        *s)   echo "${word%s}" ;;
        *)    echo "$word" ;;
    esac
}

# Verifie si un dossier existe deja
check_module_exists() {
    if [ -d "${SRC_DIR}/${1}" ]; then
        return 0
    fi
    return 1
}

# ==============================================================================
# VALIDATION DES ARGUMENTS
# ==============================================================================

# Affiche l'aide
show_help() {
    cat << EOF
Usage: $(basename "$0") <nom-module> [options]

Genere un module NestJS complet avec le pattern CQRS (41DEVS Standard).

Arguments:
  nom-module    Nom du module en kebab-case (ex: products, user-profiles)

Options:
  --dry-run     Affiche ce qui serait cree sans rien creer
  --no-queries  Ne genere pas les fichiers de queries
  --no-commands Ne genere pas les fichiers de commands
  --force       Ecrase le module s'il existe deja
  -h, --help    Affiche cette aide

Exemples:
  $(basename "$0") products
  $(basename "$0") user-profiles --dry-run
  $(basename "$0") orders --force

Structure generee:
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
EOF
}

# Parse des arguments
DRY_RUN=false
NO_QUERIES=false
NO_COMMANDS=false
FORCE=false
MODULE_NAME=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --no-queries)
            NO_QUERIES=true
            shift
            ;;
        --no-commands)
            NO_COMMANDS=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        -*)
            error "Option inconnue: $1. Utilisez --help pour voir les options disponibles."
            ;;
        *)
            if [ -z "$MODULE_NAME" ]; then
                MODULE_NAME="$1"
            else
                error "Argument inattendu: $1"
            fi
            shift
            ;;
    esac
done

# Verification du nom du module
if [ -z "$MODULE_NAME" ]; then
    error "Le nom du module est requis. Utilisez --help pour voir l'usage."
fi

# Validation du format du nom (kebab-case, lettres minuscules et tirets uniquement)
if ! echo "$MODULE_NAME" | grep -qE '^[a-z][a-z0-9-]*[a-z0-9]$|^[a-z]$'; then
    error "Le nom du module doit etre en kebab-case (ex: products, user-profiles)"
fi

# ==============================================================================
# PREPARATION DES NOMS
# ==============================================================================

# Noms derives du module
SINGULAR_NAME=$(to_singular "$MODULE_NAME")
MODULE_PASCAL=$(to_pascal_case "$MODULE_NAME")
SINGULAR_PASCAL=$(to_pascal_case "$SINGULAR_NAME")
MODULE_CAMEL=$(to_camel_case "$MODULE_NAME")
SINGULAR_CAMEL=$(to_camel_case "$SINGULAR_NAME")

# Chemins des fichiers
MODULE_DIR="${SRC_DIR}/${MODULE_NAME}"

# ==============================================================================
# VERIFICATION PRE-GENERATION
# ==============================================================================

info "Preparation de la generation du module: ${MODULE_NAME}"
info "  - Module (plural):  ${MODULE_NAME} -> ${MODULE_PASCAL}"
info "  - Entity (singular): ${SINGULAR_NAME} -> ${SINGULAR_PASCAL}"

# Verification si le module existe deja
if check_module_exists "$MODULE_NAME"; then
    if [ "$FORCE" = true ]; then
        warn "Le module ${MODULE_NAME} existe deja. Il sera ecrase (--force)."
        if [ "$DRY_RUN" = false ]; then
            rm -rf "${MODULE_DIR}"
        fi
    else
        error "Le module ${MODULE_NAME} existe deja. Utilisez --force pour l'ecraser."
    fi
fi

# Mode dry-run
if [ "$DRY_RUN" = true ]; then
    info "Mode dry-run active. Aucun fichier ne sera cree."
    info ""
    info "Fichiers qui seraient crees:"
    echo "  ${MODULE_DIR}/${MODULE_NAME}.module.ts"
    echo "  ${MODULE_DIR}/${MODULE_NAME}.controller.ts"
    echo "  ${MODULE_DIR}/dto/create-${SINGULAR_NAME}.dto.ts"
    echo "  ${MODULE_DIR}/dto/update-${SINGULAR_NAME}.dto.ts"
    echo "  ${MODULE_DIR}/models/${SINGULAR_NAME}.entity.ts"
    if [ "$NO_COMMANDS" = false ]; then
        echo "  ${MODULE_DIR}/commands/create-${SINGULAR_NAME}.command.ts"
        echo "  ${MODULE_DIR}/commands/create-${SINGULAR_NAME}.command.handler.ts"
        echo "  ${MODULE_DIR}/commands/update-${SINGULAR_NAME}.command.ts"
        echo "  ${MODULE_DIR}/commands/update-${SINGULAR_NAME}.command.handler.ts"
        echo "  ${MODULE_DIR}/commands/delete-${SINGULAR_NAME}.command.ts"
        echo "  ${MODULE_DIR}/commands/delete-${SINGULAR_NAME}.command.handler.ts"
    fi
    if [ "$NO_QUERIES" = false ]; then
        echo "  ${MODULE_DIR}/queries/get-${MODULE_NAME}.query.ts"
        echo "  ${MODULE_DIR}/queries/get-${MODULE_NAME}.query.handler.ts"
        echo "  ${MODULE_DIR}/queries/get-${SINGULAR_NAME}-by-id.query.ts"
        echo "  ${MODULE_DIR}/queries/get-${SINGULAR_NAME}-by-id.query.handler.ts"
    fi
    exit 0
fi

# ==============================================================================
# CREATION DES DOSSIERS
# ==============================================================================

info "Creation de la structure de dossiers..."
mkdir -p "${MODULE_DIR}/dto"
mkdir -p "${MODULE_DIR}/models"
[ "$NO_COMMANDS" = false ] && mkdir -p "${MODULE_DIR}/commands"
[ "$NO_QUERIES" = false ] && mkdir -p "${MODULE_DIR}/queries"

# ==============================================================================
# GENERATION DES FICHIERS - ENTITY
# ==============================================================================

info "Generation de l'entity..."
cat > "${MODULE_DIR}/models/${SINGULAR_NAME}.entity.ts" << EOF
// src/${MODULE_NAME}/models/${SINGULAR_NAME}.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
} from 'typeorm';

/**
 * Entity ${SINGULAR_PASCAL}
 * Represente la table '${MODULE_NAME}' dans la base de donnees
 */
@Entity('${MODULE_NAME}')
export class ${SINGULAR_PASCAL} {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 255 })
  name: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @DeleteDateColumn()
  deletedAt?: Date;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF
success "Entity: ${SINGULAR_NAME}.entity.ts"

# ==============================================================================
# GENERATION DES FICHIERS - DTOs
# ==============================================================================

info "Generation des DTOs..."

# Create DTO
cat > "${MODULE_DIR}/dto/create-${SINGULAR_NAME}.dto.ts" << EOF
// src/${MODULE_NAME}/dto/create-${SINGULAR_NAME}.dto.ts
import { IsString, IsNotEmpty, IsOptional, MaxLength } from 'class-validator';

/**
 * DTO pour la creation d'un ${SINGULAR_PASCAL}
 * Valide les donnees entrantes pour POST /${MODULE_NAME}
 */
export class Create${SINGULAR_PASCAL}Dto {
  @IsString()
  @IsNotEmpty({ message: 'Le nom est obligatoire' })
  @MaxLength(255, { message: 'Le nom ne doit pas depasser 255 caracteres' })
  name: string;

  @IsString()
  @IsOptional()
  description?: string;
}
EOF
success "DTO: create-${SINGULAR_NAME}.dto.ts"

# Update DTO
cat > "${MODULE_DIR}/dto/update-${SINGULAR_NAME}.dto.ts" << EOF
// src/${MODULE_NAME}/dto/update-${SINGULAR_NAME}.dto.ts
import { PartialType } from '@nestjs/mapped-types';
import { Create${SINGULAR_PASCAL}Dto } from './create-${SINGULAR_NAME}.dto';

/**
 * DTO pour la mise a jour d'un ${SINGULAR_PASCAL}
 * Herite de Create${SINGULAR_PASCAL}Dto avec tous les champs optionnels
 */
export class Update${SINGULAR_PASCAL}Dto extends PartialType(Create${SINGULAR_PASCAL}Dto) {}
EOF
success "DTO: update-${SINGULAR_NAME}.dto.ts"

# ==============================================================================
# GENERATION DES FICHIERS - COMMANDS
# ==============================================================================

if [ "$NO_COMMANDS" = false ]; then
    info "Generation des commands..."

    # --- CREATE COMMAND ---
    cat > "${MODULE_DIR}/commands/create-${SINGULAR_NAME}.command.ts" << EOF
// src/${MODULE_NAME}/commands/create-${SINGULAR_NAME}.command.ts

/**
 * Command pour creer un ${SINGULAR_PASCAL}
 * Transporte les donnees necessaires pour l'operation de creation
 */
export class Create${SINGULAR_PASCAL}Command {
  constructor(
    public readonly name: string,
    public readonly description?: string,
  ) {}
}
EOF
    success "Command: create-${SINGULAR_NAME}.command.ts"

    # --- CREATE COMMAND HANDLER ---
    cat > "${MODULE_DIR}/commands/create-${SINGULAR_NAME}.command.handler.ts" << EOF
// src/${MODULE_NAME}/commands/create-${SINGULAR_NAME}.command.handler.ts
import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Logger } from '@nestjs/common';

import { Create${SINGULAR_PASCAL}Command } from './create-${SINGULAR_NAME}.command';
import { ${SINGULAR_PASCAL} } from '../models/${SINGULAR_NAME}.entity';

/**
 * Handler pour Create${SINGULAR_PASCAL}Command
 * Execute la logique metier de creation d'un ${SINGULAR_PASCAL}
 */
@CommandHandler(Create${SINGULAR_PASCAL}Command)
export class Create${SINGULAR_PASCAL}CommandHandler implements ICommandHandler<Create${SINGULAR_PASCAL}Command> {
  private readonly logger = new Logger(Create${SINGULAR_PASCAL}CommandHandler.name);

  constructor(
    @InjectRepository(${SINGULAR_PASCAL})
    private readonly ${SINGULAR_CAMEL}Repository: Repository<${SINGULAR_PASCAL}>,
  ) {}

  async execute(command: Create${SINGULAR_PASCAL}Command): Promise<${SINGULAR_PASCAL}> {
    this.logger.log(\`Creation d'un nouveau ${SINGULAR_PASCAL}: "\${command.name}"\`);

    const ${SINGULAR_CAMEL} = this.${SINGULAR_CAMEL}Repository.create({
      name: command.name,
      description: command.description,
    });

    const saved${SINGULAR_PASCAL} = await this.${SINGULAR_CAMEL}Repository.save(${SINGULAR_CAMEL});

    this.logger.log(\`${SINGULAR_PASCAL} cree avec succes (ID: \${saved${SINGULAR_PASCAL}.id})\`);

    return saved${SINGULAR_PASCAL};
  }
}
EOF
    success "Handler: create-${SINGULAR_NAME}.command.handler.ts"

    # --- UPDATE COMMAND ---
    cat > "${MODULE_DIR}/commands/update-${SINGULAR_NAME}.command.ts" << EOF
// src/${MODULE_NAME}/commands/update-${SINGULAR_NAME}.command.ts

/**
 * Command pour mettre a jour un ${SINGULAR_PASCAL}
 * Transporte les donnees necessaires pour l'operation de mise a jour
 */
export class Update${SINGULAR_PASCAL}Command {
  constructor(
    public readonly id: number,
    public readonly name?: string,
    public readonly description?: string,
  ) {}
}
EOF
    success "Command: update-${SINGULAR_NAME}.command.ts"

    # --- UPDATE COMMAND HANDLER ---
    cat > "${MODULE_DIR}/commands/update-${SINGULAR_NAME}.command.handler.ts" << EOF
// src/${MODULE_NAME}/commands/update-${SINGULAR_NAME}.command.handler.ts
import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Logger, NotFoundException } from '@nestjs/common';

import { Update${SINGULAR_PASCAL}Command } from './update-${SINGULAR_NAME}.command';
import { ${SINGULAR_PASCAL} } from '../models/${SINGULAR_NAME}.entity';

/**
 * Handler pour Update${SINGULAR_PASCAL}Command
 * Execute la logique metier de mise a jour d'un ${SINGULAR_PASCAL}
 */
@CommandHandler(Update${SINGULAR_PASCAL}Command)
export class Update${SINGULAR_PASCAL}CommandHandler implements ICommandHandler<Update${SINGULAR_PASCAL}Command> {
  private readonly logger = new Logger(Update${SINGULAR_PASCAL}CommandHandler.name);

  constructor(
    @InjectRepository(${SINGULAR_PASCAL})
    private readonly ${SINGULAR_CAMEL}Repository: Repository<${SINGULAR_PASCAL}>,
  ) {}

  async execute(command: Update${SINGULAR_PASCAL}Command): Promise<${SINGULAR_PASCAL}> {
    this.logger.log(\`Mise a jour du ${SINGULAR_PASCAL} ID: \${command.id}\`);

    // Verifier que l'entite existe
    const ${SINGULAR_CAMEL} = await this.${SINGULAR_CAMEL}Repository.findOne({
      where: { id: command.id },
    });

    if (!${SINGULAR_CAMEL}) {
      throw new NotFoundException(\`${SINGULAR_PASCAL} avec l'ID \${command.id} non trouve\`);
    }

    // Mettre a jour uniquement les champs fournis
    if (command.name !== undefined) ${SINGULAR_CAMEL}.name = command.name;
    if (command.description !== undefined) ${SINGULAR_CAMEL}.description = command.description;

    const updated${SINGULAR_PASCAL} = await this.${SINGULAR_CAMEL}Repository.save(${SINGULAR_CAMEL});

    this.logger.log(\`${SINGULAR_PASCAL} \${command.id} mis a jour avec succes\`);

    return updated${SINGULAR_PASCAL};
  }
}
EOF
    success "Handler: update-${SINGULAR_NAME}.command.handler.ts"

    # --- DELETE COMMAND ---
    cat > "${MODULE_DIR}/commands/delete-${SINGULAR_NAME}.command.ts" << EOF
// src/${MODULE_NAME}/commands/delete-${SINGULAR_NAME}.command.ts

/**
 * Command pour supprimer un ${SINGULAR_PASCAL}
 * Utilise le soft delete (marque comme supprime sans effacer)
 */
export class Delete${SINGULAR_PASCAL}Command {
  constructor(public readonly id: number) {}
}
EOF
    success "Command: delete-${SINGULAR_NAME}.command.ts"

    # --- DELETE COMMAND HANDLER ---
    cat > "${MODULE_DIR}/commands/delete-${SINGULAR_NAME}.command.handler.ts" << EOF
// src/${MODULE_NAME}/commands/delete-${SINGULAR_NAME}.command.handler.ts
import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Logger, NotFoundException } from '@nestjs/common';

import { Delete${SINGULAR_PASCAL}Command } from './delete-${SINGULAR_NAME}.command';
import { ${SINGULAR_PASCAL} } from '../models/${SINGULAR_NAME}.entity';

/**
 * Handler pour Delete${SINGULAR_PASCAL}Command
 * Execute le soft delete d'un ${SINGULAR_PASCAL}
 */
@CommandHandler(Delete${SINGULAR_PASCAL}Command)
export class Delete${SINGULAR_PASCAL}CommandHandler implements ICommandHandler<Delete${SINGULAR_PASCAL}Command> {
  private readonly logger = new Logger(Delete${SINGULAR_PASCAL}CommandHandler.name);

  constructor(
    @InjectRepository(${SINGULAR_PASCAL})
    private readonly ${SINGULAR_CAMEL}Repository: Repository<${SINGULAR_PASCAL}>,
  ) {}

  async execute(command: Delete${SINGULAR_PASCAL}Command): Promise<void> {
    this.logger.log(\`Suppression du ${SINGULAR_PASCAL} ID: \${command.id}\`);

    // Verifier que l'entite existe
    const ${SINGULAR_CAMEL} = await this.${SINGULAR_CAMEL}Repository.findOne({
      where: { id: command.id },
    });

    if (!${SINGULAR_CAMEL}) {
      throw new NotFoundException(\`${SINGULAR_PASCAL} avec l'ID \${command.id} non trouve\`);
    }

    // Soft delete (utilise DeleteDateColumn)
    await this.${SINGULAR_CAMEL}Repository.softDelete(command.id);

    this.logger.log(\`${SINGULAR_PASCAL} \${command.id} supprime avec succes\`);
  }
}
EOF
    success "Handler: delete-${SINGULAR_NAME}.command.handler.ts"
fi

# ==============================================================================
# GENERATION DES FICHIERS - QUERIES
# ==============================================================================

if [ "$NO_QUERIES" = false ]; then
    info "Generation des queries..."

    # Get All Query
    cat > "${MODULE_DIR}/queries/get-${MODULE_NAME}.query.ts" << EOF
// src/${MODULE_NAME}/queries/get-${MODULE_NAME}.query.ts

/**
 * Query pour recuperer la liste des ${MODULE_PASCAL}
 */
export class Get${MODULE_PASCAL}Query {
  constructor() {}
}
EOF
    success "Query: get-${MODULE_NAME}.query.ts"

    # Get All Query Handler
    cat > "${MODULE_DIR}/queries/get-${MODULE_NAME}.query.handler.ts" << EOF
// src/${MODULE_NAME}/queries/get-${MODULE_NAME}.query.handler.ts
import { QueryHandler, IQueryHandler } from '@nestjs/cqrs';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Logger } from '@nestjs/common';

import { Get${MODULE_PASCAL}Query } from './get-${MODULE_NAME}.query';
import { ${SINGULAR_PASCAL} } from '../models/${SINGULAR_NAME}.entity';

/**
 * Handler pour Get${MODULE_PASCAL}Query
 * Recupere la liste de tous les ${MODULE_PASCAL}
 */
@QueryHandler(Get${MODULE_PASCAL}Query)
export class Get${MODULE_PASCAL}QueryHandler implements IQueryHandler<Get${MODULE_PASCAL}Query> {
  private readonly logger = new Logger(Get${MODULE_PASCAL}QueryHandler.name);

  constructor(
    @InjectRepository(${SINGULAR_PASCAL})
    private readonly ${SINGULAR_CAMEL}Repository: Repository<${SINGULAR_PASCAL}>,
  ) {}

  async execute(query: Get${MODULE_PASCAL}Query): Promise<${SINGULAR_PASCAL}[]> {
    this.logger.log('Recuperation de la liste des ${MODULE_PASCAL}');
    return this.${SINGULAR_CAMEL}Repository.find();
  }
}
EOF
    success "Handler: get-${MODULE_NAME}.query.handler.ts"

    # Get By Id Query
    cat > "${MODULE_DIR}/queries/get-${SINGULAR_NAME}-by-id.query.ts" << EOF
// src/${MODULE_NAME}/queries/get-${SINGULAR_NAME}-by-id.query.ts

/**
 * Query pour recuperer un ${SINGULAR_PASCAL} par son ID
 */
export class Get${SINGULAR_PASCAL}ByIdQuery {
  constructor(public readonly id: number) {}
}
EOF
    success "Query: get-${SINGULAR_NAME}-by-id.query.ts"

    # Get By Id Query Handler
    cat > "${MODULE_DIR}/queries/get-${SINGULAR_NAME}-by-id.query.handler.ts" << EOF
// src/${MODULE_NAME}/queries/get-${SINGULAR_NAME}-by-id.query.handler.ts
import { QueryHandler, IQueryHandler } from '@nestjs/cqrs';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Logger, NotFoundException } from '@nestjs/common';

import { Get${SINGULAR_PASCAL}ByIdQuery } from './get-${SINGULAR_NAME}-by-id.query';
import { ${SINGULAR_PASCAL} } from '../models/${SINGULAR_NAME}.entity';

/**
 * Handler pour Get${SINGULAR_PASCAL}ByIdQuery
 * Recupere un ${SINGULAR_PASCAL} specifique par son ID
 */
@QueryHandler(Get${SINGULAR_PASCAL}ByIdQuery)
export class Get${SINGULAR_PASCAL}ByIdQueryHandler implements IQueryHandler<Get${SINGULAR_PASCAL}ByIdQuery> {
  private readonly logger = new Logger(Get${SINGULAR_PASCAL}ByIdQueryHandler.name);

  constructor(
    @InjectRepository(${SINGULAR_PASCAL})
    private readonly ${SINGULAR_CAMEL}Repository: Repository<${SINGULAR_PASCAL}>,
  ) {}

  async execute(query: Get${SINGULAR_PASCAL}ByIdQuery): Promise<${SINGULAR_PASCAL}> {
    this.logger.log(\`Recuperation du ${SINGULAR_PASCAL} ID: \${query.id}\`);

    const ${SINGULAR_CAMEL} = await this.${SINGULAR_CAMEL}Repository.findOne({
      where: { id: query.id },
    });

    if (!${SINGULAR_CAMEL}) {
      throw new NotFoundException(\`${SINGULAR_PASCAL} avec l'ID \${query.id} non trouve\`);
    }

    return ${SINGULAR_CAMEL};
  }
}
EOF
    success "Handler: get-${SINGULAR_NAME}-by-id.query.handler.ts"
fi

# ==============================================================================
# GENERATION DES FICHIERS - CONTROLLER
# ==============================================================================

info "Generation du controller..."

cat > "${MODULE_DIR}/${MODULE_NAME}.controller.ts" << EOF
// src/${MODULE_NAME}/${MODULE_NAME}.controller.ts
import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  ParseIntPipe,
  Logger,
} from '@nestjs/common';
import { CommandBus, QueryBus } from '@nestjs/cqrs';

// DTOs
import { Create${SINGULAR_PASCAL}Dto } from './dto/create-${SINGULAR_NAME}.dto';
import { Update${SINGULAR_PASCAL}Dto } from './dto/update-${SINGULAR_NAME}.dto';

// Entity
import { ${SINGULAR_PASCAL} } from './models/${SINGULAR_NAME}.entity';
EOF

# Ajouter imports conditionnels pour Commands
if [ "$NO_COMMANDS" = false ]; then
    cat >> "${MODULE_DIR}/${MODULE_NAME}.controller.ts" << EOF

// Commands
import { Create${SINGULAR_PASCAL}Command } from './commands/create-${SINGULAR_NAME}.command';
import { Update${SINGULAR_PASCAL}Command } from './commands/update-${SINGULAR_NAME}.command';
import { Delete${SINGULAR_PASCAL}Command } from './commands/delete-${SINGULAR_NAME}.command';
EOF
fi

# Ajouter imports conditionnels pour Queries
if [ "$NO_QUERIES" = false ]; then
    cat >> "${MODULE_DIR}/${MODULE_NAME}.controller.ts" << EOF

// Queries
import { Get${MODULE_PASCAL}Query } from './queries/get-${MODULE_NAME}.query';
import { Get${SINGULAR_PASCAL}ByIdQuery } from './queries/get-${SINGULAR_NAME}-by-id.query';
EOF
fi

# Debut de la classe Controller
cat >> "${MODULE_DIR}/${MODULE_NAME}.controller.ts" << EOF

/**
 * Controller pour le module ${MODULE_PASCAL}
 * Expose les endpoints REST pour les operations CRUD
 */
@Controller('${MODULE_NAME}')
export class ${MODULE_PASCAL}Controller {
  private readonly logger = new Logger(${MODULE_PASCAL}Controller.name);

  constructor(
    private readonly commandBus: CommandBus,
    private readonly queryBus: QueryBus,
  ) {}
EOF

# Ajouter methodes GET si queries activees
if [ "$NO_QUERIES" = false ]; then
    cat >> "${MODULE_DIR}/${MODULE_NAME}.controller.ts" << EOF

  // ==========================================================================
  // QUERIES (Lecture)
  // ==========================================================================

  /**
   * GET /${MODULE_NAME}
   * Retourne la liste de tous les ${MODULE_NAME}
   */
  @Get()
  async findAll(): Promise<${SINGULAR_PASCAL}[]> {
    this.logger.log('GET /${MODULE_NAME}');
    return this.queryBus.execute(new Get${MODULE_PASCAL}Query());
  }

  /**
   * GET /${MODULE_NAME}/:id
   * Retourne un ${SINGULAR_NAME} par son ID
   */
  @Get(':id')
  async findOne(@Param('id', ParseIntPipe) id: number): Promise<${SINGULAR_PASCAL}> {
    this.logger.log(\`GET /${MODULE_NAME}/\${id}\`);
    return this.queryBus.execute(new Get${SINGULAR_PASCAL}ByIdQuery(id));
  }
EOF
fi

# Ajouter methodes POST/PATCH/DELETE si commands activees
if [ "$NO_COMMANDS" = false ]; then
    cat >> "${MODULE_DIR}/${MODULE_NAME}.controller.ts" << EOF

  // ==========================================================================
  // COMMANDS (Ecriture)
  // ==========================================================================

  /**
   * POST /${MODULE_NAME}
   * Cree un nouveau ${SINGULAR_NAME}
   */
  @Post()
  async create(@Body() dto: Create${SINGULAR_PASCAL}Dto): Promise<${SINGULAR_PASCAL}> {
    this.logger.log('POST /${MODULE_NAME}');
    return this.commandBus.execute(
      new Create${SINGULAR_PASCAL}Command(dto.name, dto.description),
    );
  }

  /**
   * PATCH /${MODULE_NAME}/:id
   * Met a jour un ${SINGULAR_NAME} existant
   */
  @Patch(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: Update${SINGULAR_PASCAL}Dto,
  ): Promise<${SINGULAR_PASCAL}> {
    this.logger.log(\`PATCH /${MODULE_NAME}/\${id}\`);
    return this.commandBus.execute(
      new Update${SINGULAR_PASCAL}Command(id, dto.name, dto.description),
    );
  }

  /**
   * DELETE /${MODULE_NAME}/:id
   * Supprime un ${SINGULAR_NAME} (soft delete)
   */
  @Delete(':id')
  async remove(@Param('id', ParseIntPipe) id: number): Promise<{ message: string }> {
    this.logger.log(\`DELETE /${MODULE_NAME}/\${id}\`);
    await this.commandBus.execute(new Delete${SINGULAR_PASCAL}Command(id));
    return { message: \`${SINGULAR_PASCAL} \${id} supprime avec succes\` };
  }
EOF
fi

# Fermer la classe
cat >> "${MODULE_DIR}/${MODULE_NAME}.controller.ts" << EOF
}
EOF

success "Controller: ${MODULE_NAME}.controller.ts"

# ==============================================================================
# GENERATION DES FICHIERS - MODULE
# ==============================================================================

info "Generation du module..."

cat > "${MODULE_DIR}/${MODULE_NAME}.module.ts" << EOF
// src/${MODULE_NAME}/${MODULE_NAME}.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CqrsModule } from '@nestjs/cqrs';

// Controller
import { ${MODULE_PASCAL}Controller } from './${MODULE_NAME}.controller';

// Entity
import { ${SINGULAR_PASCAL} } from './models/${SINGULAR_NAME}.entity';
EOF

# Imports conditionnels pour Command handlers
if [ "$NO_COMMANDS" = false ]; then
    cat >> "${MODULE_DIR}/${MODULE_NAME}.module.ts" << EOF

// Command Handlers
import { Create${SINGULAR_PASCAL}CommandHandler } from './commands/create-${SINGULAR_NAME}.command.handler';
import { Update${SINGULAR_PASCAL}CommandHandler } from './commands/update-${SINGULAR_NAME}.command.handler';
import { Delete${SINGULAR_PASCAL}CommandHandler } from './commands/delete-${SINGULAR_NAME}.command.handler';
EOF
fi

# Imports conditionnels pour Query handlers
if [ "$NO_QUERIES" = false ]; then
    cat >> "${MODULE_DIR}/${MODULE_NAME}.module.ts" << EOF

// Query Handlers
import { Get${MODULE_PASCAL}QueryHandler } from './queries/get-${MODULE_NAME}.query.handler';
import { Get${SINGULAR_PASCAL}ByIdQueryHandler } from './queries/get-${SINGULAR_NAME}-by-id.query.handler';
EOF
fi

# Construire les tableaux de handlers
COMMAND_HANDLERS=""
QUERY_HANDLERS=""

if [ "$NO_COMMANDS" = false ]; then
    COMMAND_HANDLERS="Create${SINGULAR_PASCAL}CommandHandler, Update${SINGULAR_PASCAL}CommandHandler, Delete${SINGULAR_PASCAL}CommandHandler"
fi

if [ "$NO_QUERIES" = false ]; then
    QUERY_HANDLERS="Get${MODULE_PASCAL}QueryHandler, Get${SINGULAR_PASCAL}ByIdQueryHandler"
fi

# Combiner les handlers
if [ -n "$COMMAND_HANDLERS" ] && [ -n "$QUERY_HANDLERS" ]; then
    ALL_HANDLERS="${COMMAND_HANDLERS}, ${QUERY_HANDLERS}"
elif [ -n "$COMMAND_HANDLERS" ]; then
    ALL_HANDLERS="${COMMAND_HANDLERS}"
elif [ -n "$QUERY_HANDLERS" ]; then
    ALL_HANDLERS="${QUERY_HANDLERS}"
else
    ALL_HANDLERS=""
fi

cat >> "${MODULE_DIR}/${MODULE_NAME}.module.ts" << EOF

// Regroupement des handlers pour une meilleure lisibilite
const Handlers = [${ALL_HANDLERS}];

/**
 * Module ${MODULE_PASCAL}
 * Regroupe tous les composants lies aux ${MODULE_NAME}
 */
@Module({
  imports: [
    TypeOrmModule.forFeature([${SINGULAR_PASCAL}]),
    CqrsModule,
  ],
  controllers: [${MODULE_PASCAL}Controller],
  providers: [...Handlers],
  exports: [TypeOrmModule],
})
export class ${MODULE_PASCAL}Module {}
EOF

success "Module: ${MODULE_NAME}.module.ts"

# ==============================================================================
# RESUME FINAL
# ==============================================================================

echo ""
echo "============================================================"
printf "${GREEN}GENERATION TERMINEE AVEC SUCCES${NC}\n"
echo "============================================================"
echo ""
echo "Module cree: ${MODULE_NAME}"
echo "Emplacement: ${MODULE_DIR}"
echo ""
echo "Fichiers generes:"
echo "  - ${MODULE_NAME}.module.ts"
echo "  - ${MODULE_NAME}.controller.ts"
echo "  - dto/create-${SINGULAR_NAME}.dto.ts"
echo "  - dto/update-${SINGULAR_NAME}.dto.ts"
echo "  - models/${SINGULAR_NAME}.entity.ts"
if [ "$NO_COMMANDS" = false ]; then
    echo "  - commands/create-${SINGULAR_NAME}.command.ts"
    echo "  - commands/create-${SINGULAR_NAME}.command.handler.ts"
    echo "  - commands/update-${SINGULAR_NAME}.command.ts"
    echo "  - commands/update-${SINGULAR_NAME}.command.handler.ts"
    echo "  - commands/delete-${SINGULAR_NAME}.command.ts"
    echo "  - commands/delete-${SINGULAR_NAME}.command.handler.ts"
fi
if [ "$NO_QUERIES" = false ]; then
    echo "  - queries/get-${MODULE_NAME}.query.ts"
    echo "  - queries/get-${MODULE_NAME}.query.handler.ts"
    echo "  - queries/get-${SINGULAR_NAME}-by-id.query.ts"
    echo "  - queries/get-${SINGULAR_NAME}-by-id.query.handler.ts"
fi
echo ""
echo "Prochaine etape:"
echo "  1. Importer ${MODULE_PASCAL}Module dans app.module.ts:"
echo "     import { ${MODULE_PASCAL}Module } from './${MODULE_NAME}/${MODULE_NAME}.module';"
echo ""
echo "  2. Ajouter ${MODULE_PASCAL}Module dans le tableau imports de @Module"
echo ""
echo "============================================================"