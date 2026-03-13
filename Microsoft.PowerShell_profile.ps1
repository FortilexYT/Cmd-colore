# ============================================================
#  ░█▀▀░█▀█░█░░░█▀█░█▀▄░█▀█░█▀▀░█░█
#  ░█░░░█░█░█░░░█░█░█▀▄░█▀█░▀▀█░█▀█
#  ░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀
#  ColorBash - Profil PowerShell coloré
#  Install : iwr https://raw.githubusercontent.com/FortilexYT/colorbash/main/install.ps1 | iex
# ============================================================

# ── Couleurs globales ────────────────────────────────────────
$Global:CB = @{
    Reset   = "`e[0m"
    Bold    = "`e[1m"
    Dim     = "`e[2m"

    Black   = "`e[30m";  BgBlack   = "`e[40m"
    Red     = "`e[31m";  BgRed     = "`e[41m"
    Green   = "`e[32m";  BgGreen   = "`e[42m"
    Yellow  = "`e[33m";  BgYellow  = "`e[43m"
    Blue    = "`e[34m";  BgBlue    = "`e[44m"
    Magenta = "`e[35m";  BgMagenta = "`e[45m"
    Cyan    = "`e[36m";  BgCyan    = "`e[46m"
    White   = "`e[37m";  BgWhite   = "`e[47m"

    # Couleurs vives (bright)
    BRed     = "`e[91m"
    BGreen   = "`e[92m"
    BYellow  = "`e[93m"
    BBlue    = "`e[94m"
    BMagenta = "`e[95m"
    BCyan    = "`e[96m"
    BWhite   = "`e[97m"
}

# ── Fonction utilitaire : écrire en couleur ──────────────────
function Write-Color {
    param(
        [string]$Text,
        [string]$Color = "White",
        [switch]$NoNewline
    )
    $code = $Global:CB[$Color]
    if ($NoNewline) {
        Write-Host "$code$Text$($Global:CB.Reset)" -NoNewline
    } else {
        Write-Host "$code$Text$($Global:CB.Reset)"
    }
}

# ── Git branch helper ────────────────────────────────────────
function Get-GitBranch {
    try {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($branch) {
            $status = git status --porcelain 2>$null
            $dirty  = if ($status) { "*" } else { "" }
            return " $($Global:CB.BYellow)[$($Global:CB.BGreen)$branch$($Global:CB.BRed)$dirty$($Global:CB.BYellow)]$($Global:CB.Reset)"
        }
    } catch {}
    return ""
}

# ── Prompt personnalisé ──────────────────────────────────────
function prompt {
    $lastOk  = $?
    $time    = Get-Date -Format "HH:mm:ss"
    $user    = $env:USERNAME
    $host_   = $env:COMPUTERNAME
    $pathFull = $ExecutionContext.SessionState.Path.CurrentLocation.Path
    $path    = $pathFull -replace [regex]::Escape($HOME), "~"
    $git     = Get-GitBranch
    $arrow   = if ($lastOk) { "$($Global:CB.BGreen)❯$($Global:CB.Reset)" } else { "$($Global:CB.BRed)❯$($Global:CB.Reset)" }

    # Ligne 1 : user@host  chemin  git  heure
    Write-Host ""
    Write-Host "$($Global:CB.Dim)[$time]$($Global:CB.Reset) " -NoNewline
    Write-Host "$($Global:CB.BCyan)$user$($Global:CB.Dim)@$($Global:CB.Reset)$($Global:CB.BBlue)$host_$($Global:CB.Reset)" -NoNewline
    Write-Host "$($Global:CB.Dim) in $($Global:CB.Reset)$($Global:CB.BMagenta)$path$($Global:CB.Reset)" -NoNewline
    Write-Host $git

    # Ligne 2 : flèche
    return "$arrow "
}

# ── Override Write-Error pour couleur rouge ──────────────────
$Global:ErrorView = 'NormalView'
$PSDefaultParameterValues['Out-Default:Transcript'] = $false

# Hook sur les erreurs pour les colorer
$ExecutionContext.InvokeCommand.CommandNotFoundAction = {
    param($Name, $EventArgs)
    Write-Host "$($Global:CB.BRed)✘ Commande introuvable : '$Name'$($Global:CB.Reset)"
    $EventArgs.StopSearch = $true
}

# ── Aliases raccourcis utiles ────────────────────────────────
Set-Alias ll   Get-ChildItem
Set-Alias grep Select-String
Set-Alias which Get-Command
Set-Alias touch New-Item
Set-Alias open  Invoke-Item
Set-Alias reload ". $PROFILE"

# ── ls coloré (remplacement de Get-ChildItem) ───────────────
function ls {
    param([string]$Path = ".")
    $items = Get-ChildItem -Path $Path -Force
    foreach ($item in $items) {
        if ($item.PSIsContainer) {
            Write-Host "$($Global:CB.BBlue)$($item.Name)/$($Global:CB.Reset)"
        } elseif ($item.Extension -in @('.ps1','.bat','.cmd','.exe','.sh')) {
            Write-Host "$($Global:CB.BGreen)$($item.Name)$($Global:CB.Reset)"
        } elseif ($item.Extension -in @('.zip','.rar','.7z','.tar','.gz')) {
            Write-Host "$($Global:CB.BRed)$($item.Name)$($Global:CB.Reset)"
        } elseif ($item.Extension -in @('.jpg','.jpeg','.png','.gif','.bmp','.svg','.ico')) {
            Write-Host "$($Global:CB.BMagenta)$($item.Name)$($Global:CB.Reset)"
        } elseif ($item.Name -match '^\.' -or $item.Attributes -band [System.IO.FileAttributes]::Hidden) {
            Write-Host "$($Global:CB.Dim)$($item.Name)$($Global:CB.Reset)"
        } else {
            Write-Host "$($Global:CB.BWhite)$($item.Name)$($Global:CB.Reset)"
        }
    }
}

# ── cat coloré ───────────────────────────────────────────────
function cat {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        Write-Color "✘ Fichier introuvable : $Path" -Color BRed
        return
    }
    $lines = Get-Content $Path
    $n = 1
    foreach ($line in $lines) {
        Write-Host "$($Global:CB.Dim)$("{0:D4}" -f $n)$($Global:CB.Reset)  $line"
        $n++
    }
}

# ── Bannière de démarrage ────────────────────────────────────
function Show-Banner {
    Write-Host ""
    Write-Host "$($Global:CB.BCyan)  ██████╗ ██████╗ $($Global:CB.BYellow)PowerShell$($Global:CB.Reset)"
    Write-Host "$($Global:CB.BCyan) ██╔════╝██╔══██╗$($Global:CB.Dim) ColorBash v1.0$($Global:CB.Reset)"
    Write-Host "$($Global:CB.BCyan) ██║     ██████╔╝$($Global:CB.Reset)"
    Write-Host "$($Global:CB.BCyan) ██║     ██╔══██╗$($Global:CB.Dim) by TON_USER$($Global:CB.Reset)"
    Write-Host "$($Global:CB.BCyan) ╚██████╗██████╔╝$($Global:CB.Reset)"
    Write-Host "$($Global:CB.BCyan)  ╚═════╝╚═════╝ $($Global:CB.Reset)"
    Write-Host ""
    Write-Color "  PowerShell $($PSVersionTable.PSVersion)  ·  Windows $([System.Environment]::OSVersion.Version)" -Color Dim
    Write-Host ""
}

Show-Banner
