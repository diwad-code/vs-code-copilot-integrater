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
    [switch]$SkipEnvSetup,

    # Synchronizuj tylko konfigurację MCP z VS Code bez reinstalacji pakietów npm
    [Parameter(Mandatory=$false)]
    [switch]$SyncOnly
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

# Zwraca pakiet npm z jawnie ustawioną wersją latest, jeśli nie podano wersji
function Resolve-NpmPackageSpecifier {
    param([string]$Package)

    # Szukamy ostatniego znaku @ po ostatnim ukośniku — tylko wtedy traktujemy końcówkę jako tag lub wersję
    $lastSlashIndex = $Package.LastIndexOf('/')
    $lastAtIndex = $Package.LastIndexOf('@')

    if ($lastAtIndex -gt 0 -and $lastAtIndex -gt $lastSlashIndex) {
        return $Package
    }

    # W przeciwnym razie dopinamy @latest, aby instalacja była jawna i przewidywalna
    return "$Package@latest"
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
        Description = 'Generowanie komponentów UI z promptów (wymaga MAGIC_UI_API_KEY)'
        Required    = $false
        EnvVar      = 'MAGIC_UI_API_KEY'
    }
)

function Get-TargetMcpServers {
    param(
        [object[]]$Servers,
        [string[]]$Names
    )

    if (-not $Names) {
        return $Servers
    }

    return $Servers | Where-Object { $_.Name -in $Names }
}

function Sync-VsCodeMcpConfiguration {
    param(
        [string]$SourcePath,
        [string]$DestinationPath,
        [string]$SqlitePath
    )

    if (-not (Test-Path $SourcePath)) {
        throw "Nie znaleziono pliku źródłowego: $SourcePath"
    }

    $mcpConfig = Get-Content -Path $SourcePath -Raw | ConvertFrom-Json
    if (-not $mcpConfig.servers) {
        throw 'Plik mcp-config.json nie zawiera sekcji servers.'
    }

    $sqliteDirectory = Split-Path -Path $SqlitePath -Parent
    if (-not (Test-Path $sqliteDirectory)) {
        New-Item -ItemType Directory -Path $sqliteDirectory -Force | Out-Null
    }

    if (-not (Test-Path $SqlitePath)) {
        New-Item -ItemType File -Path $SqlitePath -Force | Out-Null
        Write-Log "Utworzono lokalny plik SQLite: $SqlitePath" -Level SUCCESS
    }

    if (-not $DestinationPath) {
        Write-Log 'Brak zmiennej APPDATA — nie mogę skopiować konfiguracji MCP do VS Code.' -Level WARNING
        return
    }

    $destinationDirectory = Split-Path -Path $DestinationPath -Parent
    if (-not (Test-Path $destinationDirectory)) {
        New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
    }

    if (Test-Path $DestinationPath) {
        Write-Log "Plik mcp.json już istnieje w VS Code. Tworzę kopię zapasową..." -Level WARNING
        $backup = "$DestinationPath.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item $DestinationPath $backup
        Write-Log "Backup zapisano: $backup" -Level SUCCESS
    }

    Copy-Item $SourcePath $DestinationPath -Force
    Write-Log "Konfiguracja MCP skopiowana do: $DestinationPath" -Level SUCCESS
}

if ($SyncOnly -and $Only) {
    Write-Log 'Parametry -SyncOnly oraz -Only nie mogą być użyte razem.' -Level ERROR
    exit 1
}

$serversToInstall = Get-TargetMcpServers -Servers $mcpServers -Names $Only
if (-not $serversToInstall) {
    Write-Log 'Parametr -Only nie wskazał żadnego znanego serwera MCP.' -Level ERROR
    exit 1
}

$installed  = 0
$failed     = 0

if ($SyncOnly) {
    Write-Log 'Tryb SyncOnly — pomijam reinstalację pakietów npm i synchronizuję tylko konfigurację MCP.' -Level WARNING
}
else {
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

    # Sprawdzamy czy npm jest dostępne po weryfikacji Node.js
    try {
        $npmVersion = (npm --version 2>&1).ToString()
        Write-Log "npm $npmVersion — OK" -Level SUCCESS
    }
    catch {
        Write-Log 'npm nie jest dostępne mimo obecności Node.js. Zainstaluj ponownie Node.js LTS.' -Level ERROR
        exit 1
    }

    Write-Log "Instalacja $($serversToInstall.Count) serwerów MCP..."
    Write-Host ""

    foreach ($server in $serversToInstall) {
        Write-Log "Instaluję MCP: $($server.Name) — $($server.Description)"
        $packageSpecifier = Resolve-NpmPackageSpecifier -Package $server.Package

        try {
            if ($PSCmdlet.ShouldProcess($packageSpecifier, "npm install -g")) {
                # Instalujemy pakiet globalnie przez npm
                $output = npm install -g $packageSpecifier 2>&1

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
  3. Aby bieżąca sesja PowerShell zobaczyła nowe wartości:
     - uruchom nowy terminal (np. zamknij i otwórz ponownie VS Code),
       LUB ustaw je także w tej sesji:
       `$env:GITHUB_TOKEN = 'twój_token'`
       `$env:BRAVE_API_KEY = 'twój_klucz'`
       `$env:MAGIC_UI_API_KEY = 'twój_klucz'`

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
$vscodeMcpPath = if ($env:APPDATA) { "$env:APPDATA\Code\User\mcp.json" } else { $null }
$mcpConfigSource = Join-Path $PSScriptRoot "..\mcp\mcp-config.json"
$sqliteDatabasePath = Join-Path $PSScriptRoot "..\data\local.db"

try {
    Sync-VsCodeMcpConfiguration -SourcePath $mcpConfigSource -DestinationPath $vscodeMcpPath -SqlitePath $sqliteDatabasePath
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
if ($SyncOnly) {
    Write-Log "Synchronizacja konfiguracji MCP zakończona. Jeśli VS Code było otwarte, przeładuj okno lub uruchom aplikację ponownie." -Level SUCCESS
}
else {
    Write-Log "Uruchom ponownie VS Code aby załadować nowe narzędzia MCP" -Level SUCCESS
}
