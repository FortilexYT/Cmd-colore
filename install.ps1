# ============================================================
#  ColorBash - Installeur automatique
#  Usage : iwr https://raw.githubusercontent.com/TON_USER/colorbash/main/install.ps1 | iex
# ============================================================

$ErrorActionPreference = "Stop"
$ESC = [char]27

function cWrite($text, $color) { Write-Host "$ESC[$color`m$text$ESC[0m" }

cWrite "`n  ╔══════════════════════════════════╗" "96"
cWrite "  ║   ColorBash Installer v1.0       ║" "96"
cWrite "  ╚══════════════════════════════════╝`n" "96"

# ── Vérifier la version PowerShell ──────────────────────────
if ($PSVersionTable.PSVersion.Major -lt 5) {
    cWrite "✘ PowerShell 5+ requis. Version actuelle : $($PSVersionTable.PSVersion)" "91"
    exit 1
}

# ── Activer les couleurs ANSI (Windows 10+) ──────────────────
try {
    $key = "HKCU:\Console"
    Set-ItemProperty -Path $key -Name "VirtualTerminalLevel" -Value 1 -Type DWORD -Force
    cWrite "✔ Couleurs ANSI activées dans le registre" "92"
} catch {
    cWrite "⚠ Impossible d'activer ANSI automatiquement (non critique)" "93"
}

# ── Créer le dossier du profil si inexistant ─────────────────
$profileDir = Split-Path $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    cWrite "✔ Dossier profil créé : $profileDir" "92"
}

# ── Sauvegarder l'ancien profil ──────────────────────────────
if (Test-Path $PROFILE) {
    $backup = "$PROFILE.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $PROFILE $backup
    cWrite "✔ Ancien profil sauvegardé : $backup" "93"
}

# ── Télécharger et installer le profil ───────────────────────
$url = "https://raw.githubusercontent.com/TON_USER/colorbash/main/Microsoft.PowerShell_profile.ps1"

cWrite "  Téléchargement du profil..." "96"
try {
    Invoke-WebRequest -Uri $url -OutFile $PROFILE -UseBasicParsing
    cWrite "✔ Profil installé dans : $PROFILE" "92"
} catch {
    cWrite "✘ Erreur de téléchargement : $_" "91"
    cWrite "  → Vérifie que l'URL du repo GitHub est correcte" "33"
    exit 1
}

# ── Fin ──────────────────────────────────────────────────────
cWrite "`n  ✨ Installation terminée !" "92"
cWrite "  → Redémarre PowerShell pour voir le résultat`n" "96"

# Optionnel : recharger direct
$reload = Read-Host "  Recharger maintenant ? (o/n)"
if ($reload -eq "o" -or $reload -eq "O") {
    . $PROFILE
}
