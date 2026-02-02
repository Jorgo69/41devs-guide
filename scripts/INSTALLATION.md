# Installation Globale des Scripts 41DEVS

## Configuration Actuelle

Les scripts 41DEVS sont disponibles globalement via le PATH systeme.

```bash
# Ajoute dans ~/.bashrc
export PATH="$PATH:/home/jorgo-root/Bureau/Bureau-HorsBureau/Bureau/41devs/scripts"
```

## Usage

Depuis **n'importe quel dossier** sur le systeme :

```bash
# Generer un module CQRS
generate-module.sh products

# Initialiser un projet NestJS CQRS
setup-nestjs-cqrs.sh

# Afficher l'aide
generate-module.sh --help
```

## Comment ca marche

### Le PATH

Le `PATH` est une variable d'environnement qui contient une liste de dossiers. Quand tu tapes une commande dans le terminal, le systeme cherche un executable avec ce nom dans chaque dossier du PATH.

```bash
# Voir le PATH actuel
echo $PATH

# Resultat (exemple)
/usr/local/bin:/usr/bin:/bin:/home/user/scripts
```

### Notre configuration

On a ajoute le dossier des scripts au PATH :

```
/home/jorgo-root/Bureau/Bureau-HorsBureau/Bureau/41devs/scripts
```

Donc quand tu tapes `generate-module.sh`, le systeme :
1. Cherche dans `/usr/local/bin` → pas trouve
2. Cherche dans `/usr/bin` → pas trouve
3. Cherche dans notre dossier → trouve !
4. Execute le script

## Autres Options (Non utilisees)

### Option 2 : Alias

```bash
# Dans ~/.bashrc
alias 41-module="/chemin/vers/scripts/generate-module.sh"
alias 41-setup="/chemin/vers/scripts/setup-nestjs-cqrs.sh"
```

**Avantage** : Noms personnalises plus courts
**Inconvenient** : Faut ajouter un alias pour chaque script

### Option 3 : Liens symboliques

```bash
sudo ln -s /chemin/vers/scripts/generate-module.sh /usr/local/bin/41-module
```

**Avantage** : Disponible pour tous les utilisateurs
**Inconvenient** : Necessite sudo, plus complexe a maintenir

## Depannage

### Le script n'est pas trouve

```bash
# Recharger le bashrc
source ~/.bashrc

# Ou fermer/rouvrir le terminal
```

### Verifier que le PATH contient le dossier

```bash
echo $PATH | grep -o "41devs/scripts"
```

### Permission denied

```bash
chmod +x /home/jorgo-root/Bureau/Bureau-HorsBureau/Bureau/41devs/scripts/*.sh
```
