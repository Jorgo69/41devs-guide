#!/bin/bash

# ============================================================
# 🗄️ GENERATE-DATABASE.SH - Standard 41DEVS
# ============================================================
# Cree par Ibrahim pour 41DEVS
# Version: 1.0.0
#
# Genere la structure de base de donnees PostgreSQL:
# - database/setup-database.sql
# - database/drop-database.sql
# - scripts npm (db:setup, db:drop, db:reset)
#
# Usage:
#   generate-database.sh <database-name>
#   generate-database.sh my_project_db
#   generate-database.sh -h
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
DB_NAME=""
DB_USER="root"
DB_PASSWORD="root"

# --- Afficher l'aide ---
show_help() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          🗄️ GENERATE-DATABASE - Standard 41DEVS              ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo "  generate-database.sh <database-name>"
    echo ""
    echo -e "${YELLOW}Exemples:${NC}"
    echo "  generate-database.sh veep_backend"
    echo "  generate-database.sh my_app_db"
    echo "  generate-database.sh ecommerce"
    echo ""
    echo -e "${YELLOW}Options:${NC}"
    echo "  -h, --help     Afficher cette aide"
    echo "  -u, --user     Nom de l'utilisateur DB (defaut: root)"
    echo "  -p, --password Mot de passe DB (defaut: root)"
    echo ""
    echo -e "${YELLOW}Fichiers generes:${NC}"
    echo "  database/"
    echo "  ├── setup-database.sql"
    echo "  └── drop-database.sql"
    echo ""
    echo -e "${YELLOW}Scripts npm ajoutes:${NC}"
    echo "  npm run db:setup   - Creer la base de donnees"
    echo "  npm run db:drop    - Supprimer la base de donnees"
    echo "  npm run db:reset   - Supprimer et recreer la base"
    echo ""
}

# --- Verifier les arguments ---
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -u|--user)
                DB_USER="$2"
                shift 2
                ;;
            -p|--password)
                DB_PASSWORD="$2"
                shift 2
                ;;
            -*)
                echo -e "${RED}❌ Option inconnue: $1${NC}"
                show_help
                exit 1
                ;;
            *)
                DB_NAME="$1"
                shift
                ;;
        esac
    done

    if [[ -z "$DB_NAME" ]]; then
        echo -e "${RED}❌ Erreur: Nom de la base de donnees requis${NC}"
        show_help
        exit 1
    fi

    # Convertir en snake_case (remplacer - par _)
    DB_NAME=$(echo "$DB_NAME" | tr '-' '_' | tr '[:upper:]' '[:lower:]')
}

# --- Verifier qu'on est dans un projet Node.js ---
check_project() {
    if [[ ! -f "package.json" ]]; then
        echo -e "${RED}❌ Erreur: Vous devez etre dans un projet Node.js${NC}"
        echo -e "${YELLOW}   Verifiez que package.json existe${NC}"
        exit 1
    fi
}

# --- Verifier si le dossier database existe deja ---
check_existing() {
    if [[ -d "database" ]]; then
        echo -e "${YELLOW}⚠️  Le dossier database/ existe deja.${NC}"
        read -p "Voulez-vous ecraser les fichiers existants? (o/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Oo]$ ]]; then
            echo -e "${YELLOW}Operation annulee.${NC}"
            exit 0
        fi
    fi
}

# --- Creer la structure de dossiers ---
create_directories() {
    echo -e "${BLUE}📁 Creation du dossier database/...${NC}"
    mkdir -p database
}

# --- Creer setup-database.sql ---
create_setup_sql() {
    echo -e "${BLUE}📄 Creation de setup-database.sql...${NC}"
    
    cat > "database/setup-database.sql" << EOF
-- ============================================================
-- 🗄️ Script de creation de la base de donnees PostgreSQL
-- ============================================================
-- Executer avec: npm run db:setup
-- Ou: sudo -u postgres psql -f database/setup-database.sql
-- ============================================================

-- 1. Creer l'utilisateur ${DB_USER} avec SUPERUSER (pour dev uniquement!)
DO \$\$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${DB_USER}') THEN
        CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASSWORD}' SUPERUSER CREATEDB;
    ELSE
        -- Si l'utilisateur existe deja, lui donner SUPERUSER
        ALTER USER ${DB_USER} WITH SUPERUSER;
    END IF;
END
\$\$;

-- 2. Supprimer la base si elle existe
DROP DATABASE IF EXISTS ${DB_NAME};

-- 3. Creer la base de donnees
CREATE DATABASE ${DB_NAME} OWNER ${DB_USER};

-- 4. Se connecter a la base ${DB_NAME}
\\c ${DB_NAME}

-- 5. Changer le proprietaire du schema public
ALTER SCHEMA public OWNER TO ${DB_USER};

-- ============================================================
-- ✅ Configuration terminee !
-- 🚀 Lancer: npm run dev
-- ============================================================
EOF
}

# --- Creer drop-database.sql ---
create_drop_sql() {
    echo -e "${BLUE}📄 Creation de drop-database.sql...${NC}"
    
    cat > "database/drop-database.sql" << EOF
-- ============================================================
-- 🗑️ Script de suppression de la base de donnees PostgreSQL
-- ============================================================
-- Executer avec: npm run db:drop
-- Ou: sudo -u postgres psql -f database/drop-database.sql
-- ⚠️  ATTENTION: Cette action est irreversible !
-- ============================================================

-- Fermer toutes les connexions actives a la base
SELECT
    pg_terminate_backend (pg_stat_activity.pid)
FROM
    pg_stat_activity
WHERE
    pg_stat_activity.datname = '${DB_NAME}'
    AND pid <> pg_backend_pid ();

-- Supprimer la base de donnees
DROP DATABASE IF EXISTS ${DB_NAME};

-- ============================================================
-- ✅ Base de donnees supprimee avec succes
-- 
-- 🔄 Pour recreer la base, executer:
--    npm run db:setup
-- ============================================================
EOF
}

# --- Ajouter les scripts npm dans package.json ---
add_npm_scripts() {
    echo -e "${BLUE}📄 Ajout des scripts npm dans package.json...${NC}"
    
    # Verifier si les scripts existent deja
    if grep -q '"db:setup"' package.json; then
        echo -e "${YELLOW}⚠️  Les scripts db existent deja dans package.json${NC}"
        read -p "Voulez-vous les mettre a jour? (o/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Oo]$ ]]; then
            echo -e "${YELLOW}Scripts npm non modifies.${NC}"
            return
        fi
        
        # Supprimer les anciens scripts avec sed
        # Creer un fichier temporaire
        local temp_file=$(mktemp)
        
        # Utiliser node pour modifier le package.json proprement
        node -e "
            const fs = require('fs');
            const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
            
            pkg.scripts = pkg.scripts || {};
            pkg.scripts['db:setup'] = 'sudo -u postgres psql -f database/setup-database.sql';
            pkg.scripts['db:drop'] = 'sudo -u postgres psql -f database/drop-database.sql';
            pkg.scripts['db:reset'] = 'npm run db:drop && npm run db:setup';
            
            fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
        "
    else
        # Utiliser node pour ajouter les scripts proprement
        node -e "
            const fs = require('fs');
            const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
            
            pkg.scripts = pkg.scripts || {};
            pkg.scripts['db:setup'] = 'sudo -u postgres psql -f database/setup-database.sql';
            pkg.scripts['db:drop'] = 'sudo -u postgres psql -f database/drop-database.sql';
            pkg.scripts['db:reset'] = 'npm run db:drop && npm run db:setup';
            
            fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
        "
    fi
    
    echo -e "${GREEN}✅ Scripts npm ajoutes avec succes${NC}"
}

# --- Afficher les instructions ---
show_instructions() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          ✨ DATABASE ${DB_NAME} CONFIGUREE!            ${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}📁 Fichiers crees:${NC}"
    echo "   database/"
    echo "   ├── setup-database.sql"
    echo "   └── drop-database.sql"
    echo ""
    echo -e "${YELLOW}⚙️  Configuration:${NC}"
    echo "   Base de donnees : ${DB_NAME}"
    echo "   Utilisateur     : ${DB_USER}"
    echo "   Mot de passe    : ${DB_PASSWORD}"
    echo ""
    echo -e "${YELLOW}🚀 Commandes disponibles:${NC}"
    echo ""
    echo -e "   ${CYAN}npm run db:setup${NC}  - Creer la base de donnees"
    echo -e "   ${CYAN}npm run db:drop${NC}   - Supprimer la base de donnees"
    echo -e "   ${CYAN}npm run db:reset${NC}  - Drop + Setup (reinitialiser)"
    echo ""
    echo -e "${YELLOW}⚠️  N'oublie pas de mettre a jour ton fichier de config:${NC}"
    echo ""
    echo "   config/config.yml ou .env:"
    echo -e "   ${CYAN}database: ${DB_NAME}${NC}"
    echo -e "   ${CYAN}username: ${DB_USER}${NC}"
    echo -e "   ${CYAN}password: ${DB_PASSWORD}${NC}"
    echo ""
    echo -e "${GREEN}══════════════════════════════════════════════════════════════${NC}"
}

# ============================================================
# MAIN
# ============================================================

parse_args "$@"
check_project
check_existing
create_directories
create_setup_sql
create_drop_sql
add_npm_scripts
show_instructions
