# 🛠️ Scripts 41DEVS - NestJS CQRS

> Outils de generation de projets et modules NestJS selon le **Standard 41DEVS**
> 
> Cree par **Ibrahim** pour l'equipe 41DEVS

## 📦 Installation rapide

```bash
cd scripts
bash install.sh
source ~/.bashrc
```

## 🚀 Scripts disponibles

### setup-nestjs-cqrs.sh

Cree un projet NestJS complet avec Auth, User, et Health modules.

```bash
# Creer un projet
setup-nestjs-cqrs.sh mon-api

# Sans npm install (rapide/offline)
setup-nestjs-cqrs.sh mon-api --no-install

# Dans le dossier actuel
setup-nestjs-cqrs.sh .
```

👉 [Documentation complete](setup-nestjs-cqrs.md)

---

### generate-module.sh

Genere un module CQRS complet dans un projet existant.

```bash
cd mon-api
generate-module.sh products
```

👉 [Documentation complete](generate-module.md)

---

## 📁 Pattern CQRS 41DEVS

```
module/
├── module.controller.ts
├── module.module.ts
├── models/
│   └── entity.model/
├── commands/
│   ├── handlers/           # Logique metier
│   │   └── create-entity.command.handler/
│   └── impl/               # DTO + Validation + Swagger
│       └── create-entity.command/
└── queries/
    ├── handlers/
    └── impl/
```

**Points cles:**
- Pas de DTOs separes - les Commands/Queries sont les DTOs
- Configuration YAML (pas de .env)
- Chaque handler dans son propre dossier

---

## 🔧 Configuration

Les projets utilisent `src/config/default.yml`:

```yaml
database:
  host: localhost
  port: 5432
  username: postgres
  password: postgres
  database: my_database

jwt:
  secret: "CHANGE-ME"
  expireIn: "7d"
```

---

## 📚 Documentation

| Fichier | Description |
|---------|-------------|
| [setup-nestjs-cqrs.md](setup-nestjs-cqrs.md) | Creation de projets |
| [generate-module.md](generate-module.md) | Generation de modules |
| [INSTALLATION.md](INSTALLATION.md) | Configuration PATH |

---

## 🤝 Contribution

Standard 41DEVS - Contributions bienvenues!

1. Fork le repo
2. Creer une branche
3. Commit les changements
4. Ouvrir une Pull Request

---

**MIT License** - Created by Ibrahim for 41DEVS
