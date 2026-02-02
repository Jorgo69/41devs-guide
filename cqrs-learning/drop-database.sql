-- ============================================================
-- 🗑️ Script de suppression de la base de données PostgreSQL
-- ============================================================
-- Exécuter avec: sudo -u postgres psql -f drop-database.sql
-- ⚠️  ATTENTION: Cette action est irréversible !
-- ============================================================
-- Fermer toutes les connexions actives à la base
SELECT
    pg_terminate_backend (pg_stat_activity.pid)
FROM
    pg_stat_activity
WHERE
    pg_stat_activity.datname = 'cqrs_learning'
    AND pid <> pg_backend_pid ();

-- Supprimer la base de données
DROP DATABASE IF EXISTS cqrs_learning;

-- ============================================================
-- ✅ Base de données supprimée avec succès
-- 
-- 🔄 Pour recréer la base, exécuter:
--    sudo -u postgres psql -f setup-database.sql
-- ============================================================