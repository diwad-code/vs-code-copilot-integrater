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

function Get-RecommendationList {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        throw "Nie znaleziono pliku z rekomendacjami rozszerzeń: $Path"
    }

    # extensions.json jest plikiem JSONC z komentarzami całoliniowymi
    $rawContent = Get-Content -Path $Path -Raw
    $jsonContent = $rawContent -replace '(?m)^\s*//.*(?:\r?\n)?', ''
    $config = $jsonContent | ConvertFrom-Json

    if (-not $config.recommendations -or $config.recommendations.Count -eq 0) {
        throw "Plik $Path nie zawiera żadnych rekomendowanych rozszerzeń."
    }

    return @($config.recommendations | ForEach-Object { $_.ToString() })
}

$workspaceRoot = Split-Path -Path $PSScriptRoot -Parent
$extensionsConfigPath = Join-Path $workspaceRoot '.vscode/extensions.json'
$extensions = Get-RecommendationList -Path $extensionsConfigPath
Write-Log "Wczytano listę rozszerzeń z: $extensionsConfigPath" -Level SUCCESS

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
