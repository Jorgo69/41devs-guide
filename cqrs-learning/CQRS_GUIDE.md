# 📚 Guide CQRS - Référence Rapide

## 🎯 Le Pattern CQRS en 30 Secondes

```
           HTTP Request
                │
        ┌───────▼───────┐
        │  Controller   │  ← Point d'entrée (routes HTTP)
        └───────┬───────┘
                │
    ┌───────────┴───────────┐
    │                       │
┌───▼───┐              ┌────▼────┐
│Command│              │  Query  │
│ Bus   │              │   Bus   │
└───┬───┘              └────┬────┘
    │                       │
    │ POST/PUT/DELETE       │ GET
    │ (Écriture)            │ (Lecture)
    │                       │
┌───▼───────────┐    ┌──────▼──────┐
│ Command       │    │   Query     │
│ Handler       │    │   Handler   │
│ (logique      │    │ (lecture    │
│  métier)      │    │  simple)    │
└───────────────┘    └─────────────┘
```

---

## 📁 Structure d'un Module CQRS

```
src/todos/
├── todos.module.ts          # Déclaration du module
├── todos.controller.ts      # Routes HTTP
│
├── models/
│   └── todo.entity.ts       # Modèle DB (= Eloquent Model)
│
├── dto/
│   ├── create-todo.dto.ts   # Validation create (= FormRequest)
│   └── update-todo.dto.ts   # Validation update
│
├── commands/                # ÉCRITURES (POST/PUT/DELETE)
│   ├── create-todo.command.ts
│   ├── create-todo.command.handler.ts
│   ├── update-todo.command.ts
│   ├── update-todo.command.handler.ts
│   ├── delete-todo.command.ts
│   └── delete-todo.command.handler.ts
│
└── queries/                 # LECTURES (GET)
    ├── get-todos.query.ts
    ├── get-todos.query.handler.ts
    ├── get-todo-by-id.query.ts
    └── get-todo-by-id.query.handler.ts
```

---

## 🔄 Flux CQRS

### Écriture (POST /todos)
```
1. Controller reçoit POST /todos
2. ValidationPipe valide le CreateTodoDto
3. Controller crée CreateTodoCommand
4. CommandBus.execute(command)
5. CreateTodoCommandHandler.execute()
6. Handler sauvegarde en DB
7. Retour du Todo créé
```

### Lecture (GET /todos)
```
1. Controller reçoit GET /todos
2. Controller crée GetTodosQuery
3. QueryBus.execute(query)
4. GetTodosQueryHandler.execute()
5. Handler lit la DB
6. Retour de la liste
```

---

## 📝 Templates de Code

### Command (Écriture)
```typescript
// create-user.command.ts
export class CreateUserCommand {
  constructor(
    public readonly name: string,
    public readonly email: string,
  ) {}
}
```

### Command Handler
```typescript
// create-user.command.handler.ts
@CommandHandler(CreateUserCommand)
export class CreateUserCommandHandler implements ICommandHandler<CreateUserCommand> {
  constructor(
    @InjectRepository(User) private repo: Repository<User>,
  ) {}

  async execute(command: CreateUserCommand) {
    const user = this.repo.create({ ...command });
    return this.repo.save(user);
  }
}
```

### Query (Lecture)
```typescript
// get-users.query.ts
export class GetUsersQuery {
  constructor(public readonly status?: string) {}
}
```

### Query Handler
```typescript
// get-users.query.handler.ts
@QueryHandler(GetUsersQuery)
export class GetUsersQueryHandler implements IQueryHandler<GetUsersQuery> {
  constructor(
    @InjectRepository(User) private repo: Repository<User>,
  ) {}

  async execute(query: GetUsersQuery) {
    return this.repo.find({ where: { status: query.status } });
  }
}
```

---

## 🔑 Analogies Laravel

| Laravel | NestJS + CQRS |
|---------|---------------|
| `FormRequest` | `DTO` + `class-validator` |
| `Model` | `Entity` + TypeORM |
| `Controller@store` | `Controller` → `CommandBus` → `Handler` |
| `Controller@index` | `Controller` → `QueryBus` → `Handler` |
| `ServiceProvider` | `Module` |
| `Middleware` | `Guard`, `Interceptor`, `Pipe` |

---

## 🚀 Commandes Utiles

```bash
# Lancer le serveur
npm run start:dev

# Générer un module
nest generate module users

# Générer un controller
nest generate controller users

# Build production
npm run build
```
