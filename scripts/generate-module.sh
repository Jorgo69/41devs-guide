#!/bin/bash

# ============================================================
# 🔧 GENERATE-MODULE.SH - Standard 41DEVS
# ============================================================
# Cree par Ibrahim pour 41DEVS
# Version: 2.0.0
#
# Genere un module NestJS avec le pattern CQRS 41DEVS:
# - Structure Handler/Impl (pas de DTOs separes)
# - Commands: create, update, delete
# - Queries: getAll, findById
#
# Usage:
#   generate-module.sh <module-name>
#   generate-module.sh products
#   generate-module.sh -h
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
MODULE_NAME=""
MODULE_NAME_LOWER=""
MODULE_NAME_UPPER=""
MODULE_NAME_PASCAL=""
ENTITY_NAME=""

# --- Afficher l'aide ---
show_help() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          🔧 GENERATE-MODULE - Standard 41DEVS                ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo "  generate-module.sh <module-name>"
    echo ""
    echo -e "${YELLOW}Exemples:${NC}"
    echo "  generate-module.sh products"
    echo "  generate-module.sh order-items"
    echo "  generate-module.sh Category"
    echo ""
    echo -e "${YELLOW}Structure generee:${NC}"
    echo "  src/<module>/"
    echo "  ├── <module>.controller.ts"
    echo "  ├── <module>.module.ts"
    echo "  ├── models/"
    echo "  │   └── <entity>.model/"
    echo "  ├── commands/"
    echo "  │   ├── handlers/"
    echo "  │   │   ├── create-<entity>.command.handler/"
    echo "  │   │   ├── update-<entity>.command.handler/"
    echo "  │   │   └── delete-<entity>.command.handler/"
    echo "  │   └── impl/"
    echo "  │       ├── create-<entity>.command/"
    echo "  │       ├── update-<entity>.command/"
    echo "  │       └── delete-<entity>.command/"
    echo "  └── queries/"
    echo "      ├── handlers/"
    echo "      │   ├── get-all.handler/"
    echo "      │   └── find-by-id.handler/"
    echo "      └── impl/"
    echo "          ├── get-all.query/"
    echo "          └── find-by-id.query/"
    echo ""
}

# --- Convertir le nom ---
convert_names() {
    # Convertir en lowercase avec tirets
    MODULE_NAME_LOWER=$(echo "$MODULE_NAME" | sed 's/\([A-Z]\)/-\1/g' | sed 's/^-//' | tr '[:upper:]' '[:lower:]')
    
    # Convertir en PascalCase
    MODULE_NAME_PASCAL=$(echo "$MODULE_NAME_LOWER" | sed -r 's/(^|-)([a-z])/\U\2/g')
    
    # Nom de l'entite (singulier)
    if [[ "$MODULE_NAME_LOWER" == *s ]]; then
        ENTITY_NAME="${MODULE_NAME_LOWER%s}"
    else
        ENTITY_NAME="$MODULE_NAME_LOWER"
    fi
    
    # Entity en PascalCase
    ENTITY_PASCAL=$(echo "$ENTITY_NAME" | sed -r 's/(^|-)([a-z])/\U\2/g')
}

# --- Verifier les arguments ---
parse_args() {
    if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        show_help
        exit 0
    fi
    
    MODULE_NAME="$1"
    convert_names
}

# --- Verifier qu'on est dans un projet NestJS ---
check_project() {
    if [[ ! -f "package.json" ]] || [[ ! -d "src" ]]; then
        echo -e "${RED}❌ Erreur: Vous devez etre dans un projet NestJS${NC}"
        echo -e "${YELLOW}   Verifiez que package.json et src/ existent${NC}"
        exit 1
    fi
}

# --- Creer la structure de dossiers ---
create_directories() {
    echo -e "${BLUE}📁 Creation de la structure pour ${MODULE_NAME_PASCAL}...${NC}"
    
    mkdir -p "src/$MODULE_NAME_LOWER/models/${ENTITY_NAME}.model"
    mkdir -p "src/$MODULE_NAME_LOWER/commands/handlers/create-${ENTITY_NAME}.command.handler"
    mkdir -p "src/$MODULE_NAME_LOWER/commands/handlers/update-${ENTITY_NAME}.command.handler"
    mkdir -p "src/$MODULE_NAME_LOWER/commands/handlers/delete-${ENTITY_NAME}.command.handler"
    mkdir -p "src/$MODULE_NAME_LOWER/commands/impl/create-${ENTITY_NAME}.command"
    mkdir -p "src/$MODULE_NAME_LOWER/commands/impl/update-${ENTITY_NAME}.command"
    mkdir -p "src/$MODULE_NAME_LOWER/commands/impl/delete-${ENTITY_NAME}.command"
    mkdir -p "src/$MODULE_NAME_LOWER/queries/handlers/get-all.handler"
    mkdir -p "src/$MODULE_NAME_LOWER/queries/handlers/find-by-id.handler"
    mkdir -p "src/$MODULE_NAME_LOWER/queries/impl/get-all.query"
    mkdir -p "src/$MODULE_NAME_LOWER/queries/impl/find-by-id.query"
}

# --- Creer le Model ---
create_model() {
    echo -e "${BLUE}📄 Creation du Model ${ENTITY_PASCAL}...${NC}"
    
    cat > "src/$MODULE_NAME_LOWER/models/${ENTITY_NAME}.model/${ENTITY_NAME}.model.ts" << EOF
/**
 * ${ENTITY_PASCAL} Entity Model - Standard 41DEVS
 */
import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('${MODULE_NAME_LOWER}')
export class ${ENTITY_PASCAL}Model {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ nullable: false })
  name: string;

  @Column({ nullable: true })
  description: string;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;
}
EOF
}

# --- Creer les Commands ---
create_commands() {
    echo -e "${BLUE}📄 Creation des Commands...${NC}"
    
    # Create Command (impl)
    cat > "src/$MODULE_NAME_LOWER/commands/impl/create-${ENTITY_NAME}.command/create-${ENTITY_NAME}.command.ts" << EOF
/**
 * Create ${ENTITY_PASCAL} Command - Standard 41DEVS
 */
import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class Create${ENTITY_PASCAL}Command {
  @ApiProperty({
    description: 'Name of the ${ENTITY_NAME}',
    example: 'My ${ENTITY_PASCAL}',
  })
  @IsNotEmpty()
  @IsString()
  name: string;

  @ApiProperty({
    description: 'Description',
    required: false,
    example: 'Description of the ${ENTITY_NAME}',
  })
  @IsOptional()
  @IsString()
  description?: string;
}
EOF

    # Create Command Handler
    cat > "src/$MODULE_NAME_LOWER/commands/handlers/create-${ENTITY_NAME}.command.handler/create-${ENTITY_NAME}.command.handler.ts" << EOF
/**
 * Create ${ENTITY_PASCAL} Command Handler - Standard 41DEVS
 */
import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { Create${ENTITY_PASCAL}Command } from '../../impl/create-${ENTITY_NAME}.command/create-${ENTITY_NAME}.command';
import { DataSource } from 'typeorm';
import { Logger } from '@nestjs/common';
import { ${ENTITY_PASCAL}Model } from '../../../models/${ENTITY_NAME}.model/${ENTITY_NAME}.model';

@CommandHandler(Create${ENTITY_PASCAL}Command)
export class Create${ENTITY_PASCAL}CommandHandler implements ICommandHandler<Create${ENTITY_PASCAL}Command> {
  private readonly logger = new Logger(Create${ENTITY_PASCAL}CommandHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(command: Create${ENTITY_PASCAL}Command): Promise<any> {
    try {
      const repository = this.dataSource.getRepository(${ENTITY_PASCAL}Model);

      const entity = repository.create({
        name: command.name,
        description: command.description,
      });

      const saved = await repository.save(entity);

      this.logger.log(\`${ENTITY_PASCAL} created: \${saved.id}\`);
      return saved;
    } catch (error) {
      this.logger.error(\`Error creating ${ENTITY_NAME}: \${error.message}\`, error.stack);
      throw error;
    }
  }
}
EOF

    # Update Command (impl)
    cat > "src/$MODULE_NAME_LOWER/commands/impl/update-${ENTITY_NAME}.command/update-${ENTITY_NAME}.command.ts" << EOF
/**
 * Update ${ENTITY_PASCAL} Command - Standard 41DEVS
 */
import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString, IsUUID } from 'class-validator';

export class Update${ENTITY_PASCAL}Command {
  @ApiProperty({
    description: '${ENTITY_PASCAL} ID',
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  @IsNotEmpty()
  @IsUUID()
  id: string;

  @ApiProperty({
    description: 'Name',
    required: false,
  })
  @IsOptional()
  @IsString()
  name?: string;

  @ApiProperty({
    description: 'Description',
    required: false,
  })
  @IsOptional()
  @IsString()
  description?: string;
}
EOF

    # Update Command Handler
    cat > "src/$MODULE_NAME_LOWER/commands/handlers/update-${ENTITY_NAME}.command.handler/update-${ENTITY_NAME}.command.handler.ts" << EOF
/**
 * Update ${ENTITY_PASCAL} Command Handler - Standard 41DEVS
 */
import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { Update${ENTITY_PASCAL}Command } from '../../impl/update-${ENTITY_NAME}.command/update-${ENTITY_NAME}.command';
import { DataSource } from 'typeorm';
import { Logger, NotFoundException } from '@nestjs/common';
import { ${ENTITY_PASCAL}Model } from '../../../models/${ENTITY_NAME}.model/${ENTITY_NAME}.model';

@CommandHandler(Update${ENTITY_PASCAL}Command)
export class Update${ENTITY_PASCAL}CommandHandler implements ICommandHandler<Update${ENTITY_PASCAL}Command> {
  private readonly logger = new Logger(Update${ENTITY_PASCAL}CommandHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(command: Update${ENTITY_PASCAL}Command): Promise<any> {
    const repository = this.dataSource.getRepository(${ENTITY_PASCAL}Model);

    const entity = await repository.findOne({ where: { id: command.id } });

    if (!entity) {
      throw new NotFoundException('${ENTITY_PASCAL} not found');
    }

    if (command.name) entity.name = command.name;
    if (command.description) entity.description = command.description;

    const updated = await repository.save(entity);

    this.logger.log(\`${ENTITY_PASCAL} updated: \${updated.id}\`);
    return updated;
  }
}
EOF

    # Delete Command (impl)
    cat > "src/$MODULE_NAME_LOWER/commands/impl/delete-${ENTITY_NAME}.command/delete-${ENTITY_NAME}.command.ts" << EOF
/**
 * Delete ${ENTITY_PASCAL} Command - Standard 41DEVS
 */
import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsUUID } from 'class-validator';

export class Delete${ENTITY_PASCAL}Command {
  @ApiProperty({
    description: '${ENTITY_PASCAL} ID',
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  @IsNotEmpty()
  @IsUUID()
  id: string;
}
EOF

    # Delete Command Handler
    cat > "src/$MODULE_NAME_LOWER/commands/handlers/delete-${ENTITY_NAME}.command.handler/delete-${ENTITY_NAME}.command.handler.ts" << EOF
/**
 * Delete ${ENTITY_PASCAL} Command Handler - Standard 41DEVS
 */
import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { Delete${ENTITY_PASCAL}Command } from '../../impl/delete-${ENTITY_NAME}.command/delete-${ENTITY_NAME}.command';
import { DataSource } from 'typeorm';
import { Logger, NotFoundException } from '@nestjs/common';
import { ${ENTITY_PASCAL}Model } from '../../../models/${ENTITY_NAME}.model/${ENTITY_NAME}.model';

@CommandHandler(Delete${ENTITY_PASCAL}Command)
export class Delete${ENTITY_PASCAL}CommandHandler implements ICommandHandler<Delete${ENTITY_PASCAL}Command> {
  private readonly logger = new Logger(Delete${ENTITY_PASCAL}CommandHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(command: Delete${ENTITY_PASCAL}Command): Promise<any> {
    const repository = this.dataSource.getRepository(${ENTITY_PASCAL}Model);

    const entity = await repository.findOne({ where: { id: command.id } });

    if (!entity) {
      throw new NotFoundException('${ENTITY_PASCAL} not found');
    }

    await repository.remove(entity);

    this.logger.log(\`${ENTITY_PASCAL} deleted: \${command.id}\`);
    return { message: '${ENTITY_PASCAL} deleted successfully' };
  }
}
EOF
}

# --- Creer les Queries ---
create_queries() {
    echo -e "${BLUE}📄 Creation des Queries...${NC}"
    
    # Get All Query (impl)
    cat > "src/$MODULE_NAME_LOWER/queries/impl/get-all.query/get-all.query.ts" << EOF
/**
 * Get All ${MODULE_NAME_PASCAL} Query - Standard 41DEVS
 */
export class GetAll${MODULE_NAME_PASCAL}Query {}
EOF

    # Get All Handler
    cat > "src/$MODULE_NAME_LOWER/queries/handlers/get-all.handler/get-all.handler.ts" << EOF
/**
 * Get All ${MODULE_NAME_PASCAL} Handler - Standard 41DEVS
 */
import { IQueryHandler, QueryHandler } from '@nestjs/cqrs';
import { GetAll${MODULE_NAME_PASCAL}Query } from '../../impl/get-all.query/get-all.query';
import { DataSource } from 'typeorm';
import { ${ENTITY_PASCAL}Model } from '../../../models/${ENTITY_NAME}.model/${ENTITY_NAME}.model';

@QueryHandler(GetAll${MODULE_NAME_PASCAL}Query)
export class GetAll${MODULE_NAME_PASCAL}Handler implements IQueryHandler<GetAll${MODULE_NAME_PASCAL}Query> {
  constructor(private readonly dataSource: DataSource) {}

  async execute(query: GetAll${MODULE_NAME_PASCAL}Query): Promise<any> {
    return this.dataSource.getRepository(${ENTITY_PASCAL}Model).find();
  }
}
EOF

    # Find By Id Query (impl)
    cat > "src/$MODULE_NAME_LOWER/queries/impl/find-by-id.query/find-by-id.query.ts" << EOF
/**
 * Find ${ENTITY_PASCAL} By Id Query - Standard 41DEVS
 */
import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsUUID } from 'class-validator';

export class Find${ENTITY_PASCAL}ByIdQuery {
  @ApiProperty({
    description: '${ENTITY_PASCAL} ID',
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  @IsNotEmpty()
  @IsUUID()
  id: string;
}
EOF

    # Find By Id Handler
    cat > "src/$MODULE_NAME_LOWER/queries/handlers/find-by-id.handler/find-by-id.handler.ts" << EOF
/**
 * Find ${ENTITY_PASCAL} By Id Handler - Standard 41DEVS
 */
import { IQueryHandler, QueryHandler } from '@nestjs/cqrs';
import { Find${ENTITY_PASCAL}ByIdQuery } from '../../impl/find-by-id.query/find-by-id.query';
import { DataSource } from 'typeorm';
import { NotFoundException } from '@nestjs/common';
import { ${ENTITY_PASCAL}Model } from '../../../models/${ENTITY_NAME}.model/${ENTITY_NAME}.model';

@QueryHandler(Find${ENTITY_PASCAL}ByIdQuery)
export class Find${ENTITY_PASCAL}ByIdHandler implements IQueryHandler<Find${ENTITY_PASCAL}ByIdQuery> {
  constructor(private readonly dataSource: DataSource) {}

  async execute(query: Find${ENTITY_PASCAL}ByIdQuery): Promise<any> {
    const entity = await this.dataSource.getRepository(${ENTITY_PASCAL}Model).findOne({
      where: { id: query.id },
    });

    if (!entity) {
      throw new NotFoundException('${ENTITY_PASCAL} not found');
    }

    return entity;
  }
}
EOF
}

# --- Creer le Controller ---
create_controller() {
    echo -e "${BLUE}📄 Creation du Controller...${NC}"
    
    cat > "src/$MODULE_NAME_LOWER/${MODULE_NAME_LOWER}.controller.ts" << EOF
/**
 * ${MODULE_NAME_PASCAL} Controller - Standard 41DEVS
 */
import { Body, Controller, Delete, Get, Post, Put, Query } from '@nestjs/common';
import { CommandBus, QueryBus } from '@nestjs/cqrs';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { Create${ENTITY_PASCAL}Command } from './commands/impl/create-${ENTITY_NAME}.command/create-${ENTITY_NAME}.command';
import { Update${ENTITY_PASCAL}Command } from './commands/impl/update-${ENTITY_NAME}.command/update-${ENTITY_NAME}.command';
import { Delete${ENTITY_PASCAL}Command } from './commands/impl/delete-${ENTITY_NAME}.command/delete-${ENTITY_NAME}.command';
import { GetAll${MODULE_NAME_PASCAL}Query } from './queries/impl/get-all.query/get-all.query';
import { Find${ENTITY_PASCAL}ByIdQuery } from './queries/impl/find-by-id.query/find-by-id.query';

@ApiTags('${MODULE_NAME_PASCAL}')
@Controller('${MODULE_NAME_LOWER}')
export class ${MODULE_NAME_PASCAL}Controller {
  constructor(
    private readonly commandBus: CommandBus,
    private readonly queryBus: QueryBus,
  ) {}

  @Post()
  @ApiOperation({ summary: 'Create a new ${ENTITY_NAME}' })
  async create(@Body() command: Create${ENTITY_PASCAL}Command) {
    return this.commandBus.execute(command);
  }

  @Get()
  @ApiOperation({ summary: 'Get all ${MODULE_NAME_LOWER}' })
  async getAll(@Query() query: GetAll${MODULE_NAME_PASCAL}Query) {
    return this.queryBus.execute(query);
  }

  @Get('by-id')
  @ApiOperation({ summary: 'Get ${ENTITY_NAME} by ID' })
  async getById(@Query() query: Find${ENTITY_PASCAL}ByIdQuery) {
    return this.queryBus.execute(query);
  }

  @Put()
  @ApiOperation({ summary: 'Update a ${ENTITY_NAME}' })
  async update(@Body() command: Update${ENTITY_PASCAL}Command) {
    return this.commandBus.execute(command);
  }

  @Delete()
  @ApiOperation({ summary: 'Delete a ${ENTITY_NAME}' })
  async delete(@Body() command: Delete${ENTITY_PASCAL}Command) {
    return this.commandBus.execute(command);
  }
}
EOF
}

# --- Creer le Module ---
create_module() {
    echo -e "${BLUE}📄 Creation du Module...${NC}"
    
    cat > "src/$MODULE_NAME_LOWER/${MODULE_NAME_LOWER}.module.ts" << EOF
/**
 * ${MODULE_NAME_PASCAL} Module - Standard 41DEVS
 */
import { Module } from '@nestjs/common';
import { CqrsModule } from '@nestjs/cqrs';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ${MODULE_NAME_PASCAL}Controller } from './${MODULE_NAME_LOWER}.controller';
import { ${ENTITY_PASCAL}Model } from './models/${ENTITY_NAME}.model/${ENTITY_NAME}.model';

// Command Handlers
import { Create${ENTITY_PASCAL}CommandHandler } from './commands/handlers/create-${ENTITY_NAME}.command.handler/create-${ENTITY_NAME}.command.handler';
import { Update${ENTITY_PASCAL}CommandHandler } from './commands/handlers/update-${ENTITY_NAME}.command.handler/update-${ENTITY_NAME}.command.handler';
import { Delete${ENTITY_PASCAL}CommandHandler } from './commands/handlers/delete-${ENTITY_NAME}.command.handler/delete-${ENTITY_NAME}.command.handler';

// Query Handlers
import { GetAll${MODULE_NAME_PASCAL}Handler } from './queries/handlers/get-all.handler/get-all.handler';
import { Find${ENTITY_PASCAL}ByIdHandler } from './queries/handlers/find-by-id.handler/find-by-id.handler';

@Module({
  imports: [
    CqrsModule,
    TypeOrmModule.forFeature([${ENTITY_PASCAL}Model]),
  ],
  controllers: [${MODULE_NAME_PASCAL}Controller],
  providers: [
    // Commands
    Create${ENTITY_PASCAL}CommandHandler,
    Update${ENTITY_PASCAL}CommandHandler,
    Delete${ENTITY_PASCAL}CommandHandler,
    // Queries
    GetAll${MODULE_NAME_PASCAL}Handler,
    Find${ENTITY_PASCAL}ByIdHandler,
  ],
})
export class ${MODULE_NAME_PASCAL}Module {}
EOF
}

# --- Afficher les instructions ---
show_instructions() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          ✨ MODULE ${MODULE_NAME_PASCAL} CREE!                          ${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}📁 Structure creee:${NC}"
    echo "   src/$MODULE_NAME_LOWER/"
    echo "   ├── ${MODULE_NAME_LOWER}.controller.ts"
    echo "   ├── ${MODULE_NAME_LOWER}.module.ts"
    echo "   ├── models/${ENTITY_NAME}.model/"
    echo "   ├── commands/handlers/ + impl/"
    echo "   └── queries/handlers/ + impl/"
    echo ""
    echo -e "${YELLOW}⚠️ Actions requises:${NC}"
    echo ""
    echo "1. Ajouter le module dans app.module.ts:"
    echo ""
    echo -e "   ${CYAN}import { ${MODULE_NAME_PASCAL}Module } from './${MODULE_NAME_LOWER}/${MODULE_NAME_LOWER}.module';${NC}"
    echo ""
    echo "   Et dans imports: ["
    echo -e "     ${CYAN}${MODULE_NAME_PASCAL}Module,${NC}"
    echo "   ]"
    echo ""
    echo "2. Ajouter l'entity dans TypeOrmModule (app.module.ts):"
    echo ""
    echo -e "   ${CYAN}import { ${ENTITY_PASCAL}Model } from './${MODULE_NAME_LOWER}/models/${ENTITY_NAME}.model/${ENTITY_NAME}.model';${NC}"
    echo ""
    echo "   entities: ["
    echo -e "     ${CYAN}${ENTITY_PASCAL}Model,${NC}"
    echo "   ]"
    echo ""
    echo -e "${GREEN}══════════════════════════════════════════════════════════════${NC}"
}

# ============================================================
# MAIN
# ============================================================

parse_args "$@"
check_project
create_directories
create_model
create_commands
create_queries
create_controller
create_module
show_instructions