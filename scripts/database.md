# Database Scripts - Documentation

## Description

Scripts SQL pour la gestion de la base de donnees PostgreSQL du projet CQRS Learning.

## Fichiers

| Fichier | Description |
|---------|-------------|
| `setup-database.sql` | Cree la base de donnees et l'utilisateur |
| `drop-database.sql` | Supprime la base de donnees |

## Setup Database

### Emplacement

```
cqrs-learning/setup-database.sql
```

### Ce que le script fait

1. Cree l'utilisateur `root` s'il n'existe pas
2. Attribue le mot de passe `root` a l'utilisateur
3. Donne les droits SUPERUSER a l'utilisateur (dev only)
4. Supprime la base de donnees existante si elle existe
5. Cree la base de donnees `cqrs_learning`
6. Definit `root` comme proprietaire de la base
7. Configure les permissions sur le schema public

### Usage

```bash
# Se connecter en tant que postgres et executer le script
sudo -u postgres psql -f setup-database.sql

# Ou via psql directement
psql -U postgres -f setup-database.sql
```

### Contenu

```sql
-- Creer l'utilisateur root s'il n'existe pas
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'root') THEN
        CREATE USER root WITH PASSWORD 'root';
    END IF;
END
$$;

-- Donner les privileges SUPERUSER (dev only)
ALTER USER root WITH SUPERUSER;

-- Supprimer la base si elle existe
DROP DATABASE IF EXISTS cqrs_learning;

-- Creer la base de donnees
CREATE DATABASE cqrs_learning OWNER root;
```

## Drop Database

### Emplacement

```
cqrs-learning/drop-database.sql
```

### Ce que le script fait

1. Deconnecte tous les utilisateurs de la base
2. Supprime la base de donnees

### Usage

```bash
# Se connecter en tant que postgres et executer le script
sudo -u postgres psql -f drop-database.sql
```

### Contenu

```sql
-- Deconnecter tous les utilisateurs
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'cqrs_learning'
AND pid <> pg_backend_pid();

-- Supprimer la base
DROP DATABASE IF EXISTS cqrs_learning;
```

## Workflow Typique

```bash
# 1. Reset complet de la base
sudo -u postgres psql -f drop-database.sql
sudo -u postgres psql -f setup-database.sql

# 2. Lancer l'application (TypeORM synchronize cree les tables)
npm run start:dev
```

## Securite

> **ATTENTION** : Ces scripts sont destines au DEVELOPPEMENT uniquement.
> L'utilisateur `root` avec SUPERUSER ne doit JAMAIS etre utilise en production.

Pour la production, utilisez un utilisateur avec des privileges limites :

```sql
CREATE USER app_user WITH PASSWORD 'secure_password';
GRANT CONNECT ON DATABASE production_db TO app_user;
GRANT USAGE ON SCHEMA public TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_user;
```

## Compatibilite

- PostgreSQL 12+
- PostgreSQL 15+ (gestion des permissions schema public)
