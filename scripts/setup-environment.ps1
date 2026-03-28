#Requires -Version 5.1
# ============================================================
# NAZWA: setup-environment.ps1
# CEL: Kompleksowe przygotowanie środowiska deweloperskiego
# UŻYCIE: .\scripts\setup-environment.ps1
# WYMAGANIA: Windows 10/11, PowerShell 5.1+, prawa administratora (preferowane)
# ============================================================

[CmdletBinding(SupportsShouldProcess)]
param(
    # Pomija instalację narzędzi które wymagają praw administratora
    [Parameter(Mandatory=$false)]
    [switch]$NoAdmin,

    # Wyświetla co by zostało zainstalowane bez faktycznej instalacji
    [Parameter(Mandatory=$false)]
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

# Standardowa funkcja logowania używana we wszystkich skryptach projektu
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet('INFO','SUCCESS','WARNING','ERROR','SECTION')]
        [string]$Level = 'INFO'
    )
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    switch ($Level) {
        'SECTION' {
            Write-Host ""
            Write-Host "══════════════════════════════════════" -ForegroundColor Magenta
            Write-Host "  $Message" -ForegroundColor Magenta
            Write-Host "══════════════════════════════════════" -ForegroundColor Magenta
        }
        default {
            $color = switch ($Level) {
                'INFO'    { 'Cyan' }
                'SUCCESS' { 'Green' }
                'WARNING' { 'Yellow' }
                'ERROR'   { 'Red' }
            }
            Write-Host "[$timestamp][$Level] $Message" -ForegroundColor $color
        }
    }
}

# Sprawdza czy polecenie istnieje w systemie
function Test-Command {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

# Instaluje oprogramowanie przez winget jeśli nie jest zainstalowane
function Install-ViaWinget {
    param(
        [string]$PackageId,     # ID pakietu w winget
        [string]$Name,          # Nazwa do wyświetlenia
        [string]$TestCommand    # Polecenie do sprawdzenia czy jest zainstalowane
    )

    if ($TestCommand -and (Test-Command $TestCommand)) {
        Write-Log "$Name jest już zainstalowany — pomijam" -Level WARNING
        return
    }

    Write-Log "Instaluję $Name przez winget..."
    if ($PSCmdlet.ShouldProcess($Name, "Zainstaluj przez winget")) {
        winget install --id $PackageId --silent --accept-source-agreements --accept-package-agreements
        if ($LASTEXITCODE -eq 0) {
            Write-Log "$Name zainstalowany" -Level SUCCESS
        }
        else {
            Write-Log "Nie udało się zainstalować $Name przez winget" -Level WARNING
        }
    }
}

# ─── SPRAWDZENIE WINGET ──────────────────────────────────────
Write-Log "KROK 1: Sprawdzenie narzędzia winget" -Level SECTION

if (-not (Test-Command winget)) {
    Write-Log "winget nie jest dostępny — instalacja przez sklep Windows..." -Level WARNING
    Write-Log "Otwórz Microsoft Store i zainstaluj 'App Installer'" -Level INFO
    Write-Log "Lub pobierz z: https://aka.ms/getwinget" -Level INFO
    # Nie przerywamy skryptu — niektóre kroki mogą działać bez winget
}
else {
    $wingetVersion = (winget --version).ToString()
    Write-Log "winget $wingetVersion — dostępny" -Level SUCCESS
}

# ─── INSTALACJA NARZĘDZI DEWELOPERSKICH ──────────────────────
Write-Log "KROK 2: Narzędzia deweloperskie" -Level SECTION

# Git — system kontroli wersji
Install-ViaWinget -PackageId 'Git.Git' -Name 'Git' -TestCommand 'git'

# Node.js LTS — wymagany dla npm i MCP serwerów
Install-ViaWinget -PackageId 'OpenJS.NodeJS.LTS' -Name 'Node.js LTS' -TestCommand 'node'

# .NET 8 SDK — dla aplikacji C#/WPF/WinForms
Install-ViaWinget -PackageId 'Microsoft.DotNet.SDK.8' -Name '.NET 8 SDK' -TestCommand 'dotnet'

# PowerShell 7 — nowoczesna wersja PowerShell (PS 5.1 to starsza)
Install-ViaWinget -PackageId 'Microsoft.PowerShell' -Name 'PowerShell 7' -TestCommand 'pwsh'

# Python 3 (opcjonalne — dla skryptów data science)
Install-ViaWinget -PackageId 'Python.Python.3.12' -Name 'Python 3.12' -TestCommand 'python'

# ─── KONFIGURACJA GIT ────────────────────────────────────────
Write-Log "KROK 3: Konfiguracja Git" -Level SECTION

if (Test-Command git) {
    # Sprawdzamy czy user.name i user.email są ustawione
    $gitName = git config --global user.name 2>$null
    $gitEmail = git config --global user.email 2>$null

    if (-not $gitName) {
        Write-Log "Konfiguracja Git: user.name nie jest ustawione" -Level WARNING
        $name = Read-Host "Podaj swoje imię i nazwisko dla Git"
        if ($name) {
            git config --global user.name $name
            Write-Log "Git user.name ustawiony: $name" -Level SUCCESS
        }
    }
    else {
        Write-Log "Git user.name: $gitName" -Level SUCCESS
    }

    if (-not $gitEmail) {
        Write-Log "Konfiguracja Git: user.email nie jest ustawione" -Level WARNING
        $email = Read-Host "Podaj swój email dla Git"
        if ($email) {
            git config --global user.email $email
            Write-Log "Git user.email ustawiony: $email" -Level SUCCESS
        }
    }
    else {
        Write-Log "Git user.email: $gitEmail" -Level SUCCESS
    }

    # Ustawiamy domyślną gałąź na 'main' (nowoczesny standard)
    git config --global init.defaultBranch main
    # Konfigurujemy koniec linii — LF dla wszystkich plików
    git config --global core.autocrlf input
    # Ustawiamy edytor na VS Code
    git config --global core.editor "code --wait"
    # Włączamy kolorowanie wyjścia Git
    git config --global color.ui auto

    Write-Log "Konfiguracja Git zakończona" -Level SUCCESS
}

# ─── INSTALACJA MODUŁÓW POWERSHELL ───────────────────────────
Write-Log "KROK 4: Moduły PowerShell" -Level SECTION

# Lista wymaganych modułów PowerShell
$psModules = @(
    @{ Name = 'PSScriptAnalyzer'; Description = 'Linter dla skryptów PowerShell' },
    @{ Name = 'Pester';           Description = 'Framework testów jednostkowych' },
    @{ Name = 'ImportExcel';      Description = 'Praca z Excel bez Office' },
    @{ Name = 'PSFramework';      Description = 'Zaawansowane logowanie i konfiguracja' },
    @{ Name = 'SqlServer';        Description = 'Moduł do pracy z SQL Server' }
)

foreach ($module in $psModules) {
    if (Get-Module -ListAvailable -Name $module.Name) {
        Write-Log "Moduł $($module.Name) — zainstalowany" -Level SUCCESS
    }
    else {
        Write-Log "Instaluję moduł: $($module.Name) — $($module.Description)"
        if ($PSCmdlet.ShouldProcess($module.Name, "Install-Module")) {
            try {
                Install-Module -Name $module.Name -Force -Scope CurrentUser -SkipPublisherCheck
                Write-Log "Zainstalowano: $($module.Name)" -Level SUCCESS
            }
            catch {
                Write-Log "Błąd instalacji $($module.Name): $_" -Level WARNING
            }
        }
    }
}

# ─── KONFIGURACJA NPM ────────────────────────────────────────
Write-Log "KROK 5: Konfiguracja npm" -Level SECTION

if (Test-Command npm) {
    $npmVersion = (npm --version).ToString()
    Write-Log "npm $npmVersion — dostępny" -Level SUCCESS

    # Instalujemy globalne narzędzia npm
    $globalNpmPackages = @(
        'typescript',         # TypeScript compiler
        'ts-node',            # Uruchamianie TS bez kompilacji
        'nodemon',            # Auto-restart serwera przy zmianach
        'prettier',           # Formatter kodu
        'eslint'              # Linter JS/TS
    )

    foreach ($pkg in $globalNpmPackages) {
        Write-Log "Instaluję globalnie: $pkg"
        if ($PSCmdlet.ShouldProcess($pkg, "npm install -g")) {
            npm install -g $pkg 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Log "Zainstalowano: $pkg" -Level SUCCESS
            }
        }
    }
}

# ─── COPILOT CLI — GOTOWOŚĆ DO PRACY ─────────────────────────
Write-Log "KROK 6: Weryfikacja gotowości Copilot CLI" -Level SECTION

if (Test-Command gh) {
    Write-Log "GitHub CLI (gh) jest dostępne" -Level SUCCESS
}
else {
    Write-Log "GitHub CLI (gh) nie jest zainstalowane — instaluję przez winget" -Level WARNING
    Install-ViaWinget -PackageId 'GitHub.cli' -Name 'GitHub CLI' -TestCommand 'gh'
}

# Informacyjnie sprawdzamy czy komenda `copilot` jest dostępna jako rozszerzenie GH CLI
try {
    if (Test-Command gh) {
        $ghExtensions = (gh extension list 2>$null) -join "`n"
        if ($ghExtensions -match 'gh-copilot') {
            Write-Log "Rozszerzenie gh-copilot jest zainstalowane" -Level SUCCESS
        }
        else {
            Write-Log "Brak rozszerzenia gh-copilot — możesz dodać: gh extension install github/gh-copilot" -Level WARNING
        }
    }
}
catch {
    Write-Log "Nie udało się zweryfikować rozszerzeń gh: $_" -Level WARNING
}

# ─── PODSUMOWANIE ────────────────────────────────────────────
Write-Log "PODSUMOWANIE KONFIGURACJI ŚRODOWISKA" -Level SECTION

# Sprawdzamy finalne wersje zainstalowanego oprogramowania
$tools = @(
    @{ Name = 'Git';         Command = 'git --version' },
    @{ Name = 'Node.js';     Command = 'node --version' },
    @{ Name = 'npm';         Command = 'npm --version' },
    @{ Name = '.NET SDK';    Command = 'dotnet --version' },
    @{ Name = 'PowerShell';  Command = 'pwsh --version' },
    @{ Name = 'Python';      Command = 'python --version' }
)

foreach ($tool in $tools) {
    try {
        $version = Invoke-Expression $tool.Command 2>&1
        Write-Host "  ✅ $($tool.Name.PadRight(15)) $version" -ForegroundColor Green
    }
    catch {
        Write-Host "  ❌ $($tool.Name.PadRight(15)) nie zainstalowany" -ForegroundColor Red
    }
}

Write-Host ""
Write-Log "Środowisko deweloperskie skonfigurowane!" -Level SUCCESS
Write-Log "Następny krok: uruchom install-extensions.ps1 i install-mcp-servers.ps1" -Level INFO
