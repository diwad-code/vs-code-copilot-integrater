#Requires -Version 5.1
# ============================================================
# NAZWA: install-mcp-servers.ps1
# CEL: Instalacja serwerów MCP (Model Context Protocol) dla GitHub Copilot
# UŻYCIE: .\scripts\install-mcp-servers.ps1
# WYMAGANIA: Node.js 18+, npm, dostęp do internetu
# DOKUMENTACJA: https://modelcontextprotocol.io
# ============================================================

[CmdletBinding(SupportsShouldProcess)]
param(
    # Opcjonalnie: instaluj tylko wybrane serwery
    [Parameter(Mandatory=$false)]
    [string[]]$Only,

    # Pomiń konfigurację zmiennych środowiskowych
    [Parameter(Mandatory=$false)]
    [switch]$SkipEnvSetup
)

$ErrorActionPreference = 'Stop'

# Funkcja logowania — standardowa dla wszystkich skryptów projektu
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet('INFO','SUCCESS','WARNING','ERROR')]
        [string]$Level = 'INFO'
    )
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $color = switch ($Level) {
        'INFO'    { 'Cyan' }
        'SUCCESS' { 'Green' }
        'WARNING' { 'Yellow' }
        'ERROR'   { 'Red' }
    }
    Write-Host "[$timestamp][$Level] $Message" -ForegroundColor $color
}

# Definicja serwerów MCP do zainstalowania
# Każdy serwer ma: nazwę, pakiet npm i opis co robi
$mcpServers = @(
    @{
        Name        = 'filesystem'
        Package     = '@modelcontextprotocol/server-filesystem'
        Description = 'Dostęp do plików i katalogów projektu'
        Required    = $true   # Wymagany — bez niego Copilot nie może czytać plików
    },
    @{
        Name        = 'memory'
        Package     = '@modelcontextprotocol/server-memory'
        Description = 'Trwała pamięć kontekstu między sesjami'
        Required    = $true
    },
    @{
        Name        = 'sequential-thinking'
        Package     = '@modelcontextprotocol/server-sequential-thinking'
        Description = 'Strukturyzowane rozwiązywanie złożonych problemów'
        Required    = $true
    },
    @{
        Name        = 'github'
        Package     = '@modelcontextprotocol/server-github'
        Description = 'Integracja z GitHub API (wymaga GITHUB_TOKEN)'
        Required    = $false  # Opcjonalny — wymaga klucza API
        EnvVar      = 'GITHUB_TOKEN'
    },
    @{
        Name        = 'brave-search'
        Package     = '@modelcontextprotocol/server-brave-search'
        Description = 'Wyszukiwanie w internecie dla research (wymaga BRAVE_API_KEY)'
        Required    = $false
        EnvVar      = 'BRAVE_API_KEY'
    },
    @{
        Name        = 'puppeteer'
        Package     = '@modelcontextprotocol/server-puppeteer'
        Description = 'Automatyzacja przeglądarki Chrome, screenshoty'
        Required    = $false
    },
    @{
        Name        = 'sqlite'
        Package     = '@modelcontextprotocol/server-sqlite'
        Description = 'Lokalna baza SQLite do testów i prototypów'
        Required    = $false
    },
    @{
        Name        = 'context7'
        Package     = '@upstash/context7-mcp'
        Description = 'Aktualna dokumentacja frameworków (React, Vue, Tailwind...)'
        Required    = $false
    },
    @{
        Name        = 'playwright'
        Package     = '@playwright/mcp'
        Description = 'Testy E2E i screenshoty dla Chrome/Firefox/Safari'
        Required    = $false
    },
    @{
        Name        = 'magic-ui'
        Package     = '@21st-dev/magic-mcp'
        Description = 'Generowanie komponentów UI (opcjonalnie — wymaga MAGIC_UI_API_KEY do działania)'
        Required    = $false
        EnvVar      = 'MAGIC_UI_API_KEY'
    }
)

# Sprawdzamy czy Node.js jest zainstalowany
Write-Log "Sprawdzanie Node.js..."
try {
    $nodeVersion = (node --version 2>&1).ToString()
    # Wyodrębniamy numer wersji (usuwa prefiks 'v')
    $nodeMajor = [int]($nodeVersion -replace 'v(\d+)\..*', '$1')

    if ($nodeMajor -lt 18) {
        # Node.js jest zbyt stary — MCP wymaga co najmniej v18
        Write-Log "Node.js v$nodeVersion jest zbyt stary. Wymagana wersja 18+." -Level ERROR
        Write-Log "Pobierz Node.js LTS ze strony: https://nodejs.org" -Level WARNING
        exit 1
    }

    Write-Log "Node.js $nodeVersion — OK" -Level SUCCESS
}
catch {
    Write-Log "Node.js nie jest zainstalowany!" -Level ERROR
    Write-Log "Pobierz Node.js LTS ze strony: https://nodejs.org" -Level WARNING

    # Próbujemy zainstalować przez winget (Windows Package Manager)
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Log "Próbuję zainstalować Node.js przez winget..."
        winget install OpenJS.NodeJS.LTS
    }
    else {
        exit 1
    }
}

# Filtrujemy serwery jeśli podano -Only parametr
$serversToInstall = if ($Only) {
    # Instalujemy tylko wymienione serwery
    $mcpServers | Where-Object { $_.Name -in $Only }
}
else {
    # Instalujemy wszystkie serwery
    $mcpServers
}

Write-Log "Instalacja $($serversToInstall.Count) serwerów MCP..."
Write-Host ""

# Liczniki podsumowania
$installed  = 0
$failed     = 0

foreach ($server in $serversToInstall) {
    Write-Log "Instaluję MCP: $($server.Name) — $($server.Description)"

    try {
        if ($PSCmdlet.ShouldProcess($server.Package, "npm install -g")) {
            # Instalujemy pakiet globalnie przez npm
            $output = npm install -g $server.Package 2>&1

            if ($LASTEXITCODE -eq 0) {
                Write-Log "Zainstalowano: $($server.Name)" -Level SUCCESS
                $installed++
            }
            else {
                Write-Log "Błąd instalacji $($server.Name): $output" -Level ERROR
                $failed++
            }
        }
    }
    catch {
        Write-Log "Wyjątek przy instalacji $($server.Name): $_" -Level ERROR
        $failed++
    }
}

Write-Host ""

# Konfiguracja zmiennych środowiskowych (opcjonalna)
if (-not $SkipEnvSetup) {
    Write-Log "Konfiguracja zmiennych środowiskowych dla MCP..." -Level INFO
    Write-Host ""

    # Sprawdzamy które wymagane zmienne środowiskowe nie są ustawione
    $missingVars = $serversToInstall |
        Where-Object { $_.EnvVar -and -not [Environment]::GetEnvironmentVariable($_.EnvVar) } |
        Select-Object -ExpandProperty EnvVar

    if ($missingVars) {
        Write-Log "Następujące zmienne środowiskowe nie są ustawione:" -Level WARNING

        foreach ($var in $missingVars) {
            Write-Host "  ⚠️  $var" -ForegroundColor Yellow
        }

        Write-Host ""
        Write-Log "Jak ustawić zmienne środowiskowe:" -Level INFO
        Write-Host @"
  1. Otwórz: Ustawienia systemu > Zaawansowane ustawienia systemu > Zmienne środowiskowe
  2. Lub użyj PowerShell (trwałe ustawienie):
     [Environment]::SetEnvironmentVariable('GITHUB_TOKEN', 'twój_token', 'User')
     [Environment]::SetEnvironmentVariable('BRAVE_API_KEY', 'twój_klucz', 'User')
     [Environment]::SetEnvironmentVariable('MAGIC_UI_API_KEY', 'twój_klucz', 'User')

  Gdzie pobrać klucze:
  - GITHUB_TOKEN: https://github.com/settings/tokens (zakres: repo, read:user)
  - BRAVE_API_KEY: https://brave.com/search/api (darmowy plan: 2000 req/miesiąc)
  - MAGIC_UI_API_KEY: https://21st.dev (opcjonalny, funkcje generowania UI)
"@ -ForegroundColor Cyan
    }
    else {
        Write-Log "Wszystkie wymagane zmienne środowiskowe są ustawione" -Level SUCCESS
    }
}

# Kopiowanie konfiguracji MCP do VS Code
Write-Log "Kopiowanie konfiguracji MCP do VS Code..." -Level INFO

# Ścieżka do globalnego pliku konfiguracyjnego MCP VS Code
$vscodeMcpPath = "$env:APPDATA\Code\User\mcp.json"
$mcpConfigSource = Join-Path $PSScriptRoot "..\mcp\mcp-config.json"

try {
    if (Test-Path $mcpConfigSource) {
        # Upewniamy się, że katalog docelowy istnieje (pierwsza konfiguracja VS Code)
        $vscodeMcpDir = Split-Path -Path $vscodeMcpPath -Parent
        if (-not (Test-Path $vscodeMcpDir)) {
            New-Item -ItemType Directory -Path $vscodeMcpDir -Force | Out-Null
        }

        if (Test-Path $vscodeMcpPath) {
            # Sprawdzamy, czy już istnieje konfiguracja - nie nadpisujemy bez pytania
            Write-Log "Plik mcp.json już istnieje w VS Code. Tworzę kopię zapasową..." -Level WARNING

            # Tworzymy backup istniejącej konfiguracji z timestampem
            $backup = "$vscodeMcpPath.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            Copy-Item $vscodeMcpPath $backup
            Write-Log "Backup zapisano: $backup" -Level SUCCESS
        }

        # Kopiujemy nową konfigurację
        Copy-Item $mcpConfigSource $vscodeMcpPath -Force
        Write-Log "Konfiguracja MCP skopiowana do: $vscodeMcpPath" -Level SUCCESS
    }
    else {
        Write-Log "Nie znaleziono pliku źródłowego: $mcpConfigSource" -Level WARNING
    }
}
catch {
    Write-Log "Nie udało się skopiować konfiguracji MCP: $_" -Level WARNING
    Write-Log "Skopiuj ręcznie plik mcp/mcp-config.json do: $vscodeMcpPath" -Level INFO
}

# Wyświetlamy podsumowanie
Write-Host ""
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  PODSUMOWANIE INSTALACJI MCP" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Łącznie:        $($serversToInstall.Count)" -ForegroundColor White
Write-Host "  Zainstalowano:  $installed" -ForegroundColor Green
Write-Host "  Błędy:          $failed" -ForegroundColor $(if ($failed -gt 0) { 'Red' } else { 'Green' })
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Log "Uruchom ponownie VS Code aby załadować nowe narzędzia MCP" -Level SUCCESS
