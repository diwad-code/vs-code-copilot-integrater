#Requires -Version 5.1
# ============================================================
# NAZWA: install-extensions.ps1
# CEL: Automatyczna instalacja wszystkich rekomendowanych rozszerzeń VS Code
# UŻYCIE: .\scripts\install-extensions.ps1
# WYMAGANIA: VS Code zainstalowany i dostępny w PATH (polecenie 'code')
# ============================================================

[CmdletBinding(SupportsShouldProcess)]
param(
    # Przełącznik wymuszający instalację nawet jeśli rozszerzenie jest już zainstalowane
    [Parameter(Mandatory=$false)]
    [switch]$Force
)

# Ustawiamy zatrzymywanie przy błędach — nie ignorujemy problemów
$ErrorActionPreference = 'Stop'

# Funkcja logowania z kolorami i timestampem
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet('INFO','SUCCESS','WARNING','ERROR')]
        [string]$Level = 'INFO'
    )
    # Formatujemy timestamp do czytelnej postaci
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

    # Wybieramy kolor w zależności od poziomu komunikatu
    $color = switch ($Level) {
        'INFO'    { 'Cyan' }
        'SUCCESS' { 'Green' }
        'WARNING' { 'Yellow' }
        'ERROR'   { 'Red' }
    }

    Write-Host "[$timestamp][$Level] $Message" -ForegroundColor $color
}

# Lista wszystkich rozszerzeń do zainstalowania
# Format: 'wydawca.identyfikator-rozszerzenia'
$extensions = @(
    # ── AI I COPILOT ──────────────────────────────────────────
    'github.copilot',               # GitHub Copilot — główny asystent AI
    'github.copilot-chat',          # GitHub Copilot Chat — czat, agenci, edycje

    # ── FORMATOWANIE I LINTING ────────────────────────────────
    'esbenp.prettier-vscode',       # Prettier — automatyczne formatowanie
    'dbaeumer.vscode-eslint',       # ESLint — wykrywanie błędów JS/TS

    # ── GIT ───────────────────────────────────────────────────
    'eamodio.gitlens',              # GitLens — zaawansowane funkcje Git
    'mhutchie.git-graph',           # Git Graph — wizualne drzewo commitów

    # ── POWERSHELL ────────────────────────────────────────────
    'ms-vscode.powershell',         # PowerShell — IntelliSense, debugger, Pester

    # ── BAZY DANYCH ───────────────────────────────────────────
    'cweijan.vscode-database-client2',          # Database Client — SQL/Oracle/MySQL
    'inferrinizzard.prettier-sql-vscode',       # SQL Formatter

    # ── WEB DEVELOPMENT ───────────────────────────────────────
    'ritwickdey.liveserver',            # Live Server — hot-reload dla HTML
    'formulahendry.auto-rename-tag',    # Auto Rename Tag — pary tagów HTML
    'formulahendry.auto-close-tag',     # Auto Close Tag
    'pranaygp.vscode-css-peek',         # CSS Peek — nawigacja do styli
    'ecmel.vscode-html-css',            # HTML CSS Support
    'bradlc.vscode-tailwindcss',        # Tailwind CSS IntelliSense
    'dsznajder.es7-react-js-snippets',  # React snippety
    'vue.volar',                         # Vue Language Features

    # ── REST API ──────────────────────────────────────────────
    'rangav.vscode-thunder-client',     # Thunder Client — REST API tester
    'humao.rest-client',                # REST Client — pliki .http

    # ── PRODUKTYWNOŚĆ ─────────────────────────────────────────
    'usernamehw.errorlens',             # Error Lens — błędy inline
    'christian-kohler.path-intellisense',   # Path Intellisense
    'coenraads.bracket-pair-colorizer-2',   # Bracket Pair Colorizer — kolorowanie par nawiasów
    'aaron-bond.better-comments',       # Better Comments — kolorowe TODO/FIXME
    'gruntfuggly.todo-tree',            # Todo Tree — lista TODO w projekcie
    'oderwat.indent-rainbow',           # Indent Rainbow — kolorowe wcięcia

    # ── MARKDOWN ──────────────────────────────────────────────
    'yzhang.markdown-all-in-one',           # Markdown All in One
    'shd101wyy.markdown-preview-enhanced',  # Markdown Preview Enhanced

    # ── DOCKER ────────────────────────────────────────────────
    'ms-azuretools.vscode-docker',      # Docker — zarządzanie kontenerami

    # ── WYGLĄD ────────────────────────────────────────────────
    'github.github-vscode-theme',       # GitHub Dark Theme
    'pkief.material-icon-theme',        # Material Icon Theme
    'johnpapa.vscode-peacock',          # Peacock — kolory pasków

    # ── NARZĘDZIA ────────────────────────────────────────────
    'adpyke.codesnap',                  # Code Snap — screenshoty kodu
    'alefragnani.bookmarks',            # Bookmarks — zakładki w kodzie
    'alefragnani.project-manager',      # Project Manager — zarządzanie projektami

    # ── .NET / C# ────────────────────────────────────────────
    'ms-dotnettools.csdevkit',              # C# Dev Kit
    'ms-dotnettools.vscode-dotnet-runtime' # .NET Install Tool
)

# Sprawdzamy czy 'code' (VS Code CLI) jest dostępne w PATH
Write-Log "Sprawdzanie dostępności VS Code CLI..."
try {
    # Uruchamiamy 'code --version' aby sprawdzić czy VS Code jest zainstalowany
    $null = & code --version 2>&1
    Write-Log "VS Code CLI jest dostępne" -Level SUCCESS
}
catch {
    # Jeśli nie znaleziono 'code', informujemy użytkownika jak rozwiązać problem
    Write-Log "VS Code CLI nie jest dostępne w PATH!" -Level ERROR
    Write-Log "Rozwiązanie: Otwórz VS Code > Ctrl+Shift+P > 'Shell Command: Install code command in PATH'" -Level WARNING
    exit 1
}

# Pobieramy listę już zainstalowanych rozszerzeń aby pominąć te które są już zainstalowane
Write-Log "Pobieranie listy zainstalowanych rozszerzeń..."
$installedExtensions = (& code --list-extensions 2>&1) | ForEach-Object { $_.ToLower() }

# Liczniki do podsumowania
$installed  = 0   # Liczba świeżo zainstalowanych rozszerzeń
$skipped    = 0   # Liczba pominiętych (już zainstalowanych)
$failed     = 0   # Liczba nieudanych instalacji
$total      = $extensions.Count

Write-Log "Znaleziono $total rozszerzeń do zainstalowania"
Write-Host ""

# Iterujemy przez każde rozszerzenie z listy
foreach ($ext in $extensions) {
    # Sprawdzamy czy rozszerzenie jest już zainstalowane (porównanie case-insensitive)
    $isInstalled = $installedExtensions -contains $ext.ToLower()

    if ($isInstalled -and -not $Force) {
        # Pomijamy już zainstalowane rozszerzenia (chyba że użyto -Force)
        Write-Log "Pominięto (już zainstalowane): $ext" -Level WARNING
        $skipped++
        continue
    }

    # Próbujemy zainstalować rozszerzenie
    Write-Log "Instaluję: $ext..."
    try {
        if ($PSCmdlet.ShouldProcess($ext, "Zainstaluj rozszerzenie VS Code")) {
            # Uruchamiamy instalację rozszerzenia przez VS Code CLI
            $result = & code --install-extension $ext --force 2>&1

            if ($LASTEXITCODE -eq 0) {
                Write-Log "Zainstalowano: $ext" -Level SUCCESS
                $installed++
            }
            else {
                Write-Log "Nie udało się zainstalować: $ext — $result" -Level ERROR
                $failed++
            }
        }
    }
    catch {
        Write-Log "Błąd instalacji $ext`: $_" -Level ERROR
        $failed++
    }
}

# Wyświetlamy podsumowanie instalacji
Write-Host ""
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  PODSUMOWANIE INSTALACJI ROZSZERZEŃ" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Łącznie:        $total" -ForegroundColor White
Write-Host "  Zainstalowano:  $installed" -ForegroundColor Green
Write-Host "  Pominięto:      $skipped" -ForegroundColor Yellow
Write-Host "  Błędy:          $failed" -ForegroundColor $(if ($failed -gt 0) { 'Red' } else { 'Green' })
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan

if ($failed -gt 0) {
    Write-Log "Niektóre rozszerzenia nie zostały zainstalowane. Sprawdź połączenie z internetem i spróbuj ponownie." -Level WARNING
    exit 1
}

Write-Log "Instalacja rozszerzeń zakończona pomyślnie! Uruchom ponownie VS Code." -Level SUCCESS
