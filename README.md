# 🎨 ColorBash — PowerShell coloré

Un profil PowerShell qui transforme ton terminal Windows en quelque chose de beau.

## ✨ Fonctionnalités

- **Prompt coloré** avec heure, user@host, chemin et branche Git
- **`ls` coloré** — dossiers en bleu, exécutables en vert, archives en rouge...
- **`cat` avec numéros de ligne**
- **Erreurs en rouge** avec message clair
- **Bannière de démarrage** stylée
- **Aliases utiles** : `ll`, `grep`, `which`, `touch`, `open`, `reload`

## 🚀 Installation (une seule commande)

Ouvre **PowerShell** (pas CMD) et colle ça :

```powershell
iwr https://raw.githubusercontent.com/TON_USER/colorbash/main/install.ps1 | iex
```

> ⚠️ Remplace `TON_USER` par ton vrai pseudo GitHub avant de partager !

## 📁 Installation manuelle

1. Télécharge `Microsoft.PowerShell_profile.ps1`
2. Copie son contenu dans ton profil PowerShell :
```powershell
notepad $PROFILE
```
3. Redémarre PowerShell

## 🎨 Couleurs du prompt

| Élément | Couleur |
|---|---|
| Heure | Gris |
| user@host | Cyan / Bleu |
| Chemin | Violet |
| Branche Git | Jaune/Vert |
| Flèche (succès) | Vert ❯ |
| Flèche (erreur) | Rouge ❯ |

## 🛠️ Personnalisation

Modifie les couleurs dans `$Global:CB` au début du fichier, ou change le prompt dans la fonction `prompt {}`.

## ℹ️ Compatibilité

- Windows 10 / 11
- PowerShell 5.1 ou PowerShell 7+
- Windows Terminal recommandé pour le meilleur rendu
