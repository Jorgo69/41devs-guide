#!/bin/bash
# ==============================================================================
# INSTALL.SH - Installation des scripts 41DEVS
# ==============================================================================
# Execute ce script apres avoir clone le repo pour :
# 1. Ajouter les permissions d'execution aux scripts
# 2. Ajouter le dossier au PATH
#
# Usage:
#   cd scripts
#   ./install.sh
# ==============================================================================

SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installation des scripts 41DEVS..."
echo "Dossier: $SCRIPTS_DIR"
echo ""

# 1. Ajouter les permissions d'execution
echo "[1/2] Ajout des permissions d'execution..."
chmod +x "$SCRIPTS_DIR"/*.sh
echo "      OK"

# 2. Ajouter au PATH si pas deja present
echo "[2/2] Configuration du PATH..."

BASHRC="$HOME/.bashrc"
ZSHRC="$HOME/.zshrc"

add_to_path() {
    local rc_file="$1"
    if [ -f "$rc_file" ]; then
        if grep -q "41devs/scripts" "$rc_file"; then
            echo "      PATH deja configure dans $(basename $rc_file)"
        else
            echo "" >> "$rc_file"
            echo "# 41DEVS Scripts - disponibles globalement" >> "$rc_file"
            echo "export PATH=\"\$PATH:$SCRIPTS_DIR\"" >> "$rc_file"
            echo "      Ajoute a $(basename $rc_file)"
        fi
    fi
}

add_to_path "$BASHRC"
add_to_path "$ZSHRC"

echo ""
echo "============================================================"
echo "Installation terminee !"
echo "============================================================"
echo ""
echo "Prochaine etape:"
echo "  source ~/.bashrc"
echo ""
echo "Ou ferme et rouvre ton terminal."
echo ""
echo "Scripts disponibles:"
echo "  - generate-module.sh"
echo "  - setup-nestjs-cqrs.sh"
echo "============================================================"
