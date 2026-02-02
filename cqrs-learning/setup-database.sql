-- ============================================================
-- 🗄️ Script de création de la base de données PostgreSQL
-- ============================================================
-- Exécuter avec: sudo -u postgres psql -f setup-database.sql
-- ============================================================

-- 1. Créer l'utilisateur root avec SUPERUSER (pour dev uniquement!)
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'root') THEN
        CREATE USER root WITH PASSWORD 'root' SUPERUSER CREATEDB;
    ELSE
        -- Si l'utilisateur existe déjà, lui donner SUPERUSER
        ALTER USER root WITH SUPERUSER;
    END IF;
END
$$;

-- 2. Supprimer la base si elle existe
DROP DATABASE IF EXISTS cqrs_learning;

-- 3. Créer la base de données
CREATE DATABASE cqrs_learning OWNER root;

-- 4. Se connecter à la base cqrs_learning
\c cqrs_learning

-- 5. Changer le propriétaire du schéma public
ALTER SCHEMA public OWNER TO root;

-- ============================================================
-- ✅ Configuration terminée !
-- 🚀 Lancer: npm run start:dev
-- ============================================================
