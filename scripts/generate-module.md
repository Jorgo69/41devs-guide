# generate-module.sh - Documentation

## 🔧 Description

Generateur de modules NestJS avec le pattern CQRS selon le **Standard 41DEVS**.

Cree par **Ibrahim** pour l'equipe 41DEVS.

## 📦 Usage

```bash
# Generer un module
generate-module.sh <module-name>

# Exemples
generate-module.sh products
generate-module.sh order-items
generate-module.sh Category

# Aide
generate-module.sh --help
```

## 📁 Structure generee

```bash
generate-module.sh products
```

Genere:

```
src/products/
├── products.controller.ts
├── products.module.ts
├── models/
│   └── product.model/
│       └── product.model.ts
├── commands/
│   ├── handlers/
│   │   ├── create-product.command.handler/
│   │   │   └── create-product.command.handler.ts
│   │   ├── update-product.command.handler/
│   │   │   └── update-product.command.handler.ts
│   │   └── delete-product.command.handler/
│   │       └── delete-product.command.handler.ts
│   └── impl/
│       ├── create-product.command/
│       │   └── create-product.command.ts
│       ├── update-product.command/
│       │   └── update-product.command.ts
│       └── delete-product.command/
│           └── delete-product.command.ts
└── queries/
    ├── handlers/
    │   ├── get-all.handler/
    │   │   └── get-all.handler.ts
    │   └── find-by-id.handler/
    │       └── find-by-id.handler.ts
    └── impl/
        ├── get-all.query/
        │   └── get-all.query.ts
        └── find-by-id.query/
            └── find-by-id.query.ts
```

## 🔐 Pattern Handler/Impl

### impl/ - Definition de la Command/Query

Contient les decorateurs de validation et Swagger:

```typescript
// commands/impl/create-product.command/create-product.command.ts
import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class CreateProductCommand {
  @ApiProperty({ description: 'Name', example: 'My Product' })
  @IsNotEmpty()
  @IsString()
  name: string;
}
```

### handlers/ - Logique metier

```typescript
// commands/handlers/create-product.command.handler/create-product.command.handler.ts
import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { CreateProductCommand } from '../../impl/create-product.command/create-product.command';

@CommandHandler(CreateProductCommand)
export class CreateProductCommandHandler implements ICommandHandler<CreateProductCommand> {
  async execute(command: CreateProductCommand): Promise<any> {
    // Logique de creation
  }
}
```

## ⚠️ Actions requises apres generation

### 1. Ajouter le module dans app.module.ts

```typescript
// Imports
import { ProductsModule } from './products/products.module';
import { ProductModel } from './products/models/product.model/product.model';

@Module({
  imports: [
    // ...
    TypeOrmModule.forRootAsync({
      // ...
      useFactory: async (configService: ConfigService) => ({
        // ...
        entities: [
          UserModel,
          ProductModel,  // Ajouter ici
        ],
      }),
    }),
    // Modules
    AuthModule,
    UserModule,
    HealthModule,
    ProductsModule,  // Ajouter ici
  ],
})
export class AppModule {}
```

### 2. Personnaliser le Model

```typescript
// src/products/models/product.model/product.model.ts
@Entity('products')
export class ProductModel {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column({ nullable: true })
  description: string;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  price: number;  // Ajouter des champs

  @Column({ default: 0 })
  stock: number;
}
```

### 3. Mettre a jour les Commands

Ajouter les nouveaux champs dans les commands/impl.

## 🎯 Endpoints generes

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /products | Create |
| GET | /products | Get all |
| GET | /products/by-id?id=xxx | Get by ID |
| PUT | /products | Update |
| DELETE | /products | Delete |

## 📝 Exemples complets

```bash
# Module pour un blog
generate-module.sh posts
generate-module.sh comments
generate-module.sh categories

# Module pour e-commerce
generate-module.sh products
generate-module.sh orders
generate-module.sh customers
```
