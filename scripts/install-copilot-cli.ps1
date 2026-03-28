#Requires -Version 5.1
# ============================================================
# NAZWA: install-copilot-cli.ps1
# CEL: Instalacja i weryfikacja GitHub CLI oraz rozszerzenia gh-copilot
# UŻYCIE: .\scripts\install-copilot-cli.ps1
# WYMAGANIA: Windows 10/11, PowerShell 5.1+, internet
# ============================================================

[CmdletBinding(SupportsShouldProcess)]
param(
    # Jeśli podano, skrypt nie będzie sugerował logowania do GitHub CLI
    [Parameter(Mandatory=$false)]
    [switch]$SkipLoginCheck
)

$ErrorActionPreference = 'Stop'

# Funkcja logująca postęp skryptu w spójnym formacie
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet('INFO','SUCCESS','WARNING','ERROR','SECTION')]
        [string]$Level = 'INFO'
    )

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

    if ($Level -eq 'SECTION') {
        Write-Host ''
        Write-Host '══════════════════════════════════════' -ForegroundColor Magenta
        Write-Host "  $Message" -ForegroundColor Magenta
        Write-Host '══════════════════════════════════════' -ForegroundColor Magenta
        return
    }

    $color = switch ($Level) {
        'INFO'    { 'Cyan' }
        'SUCCESS' { 'Green' }
        'WARNING' { 'Yellow' }
        'ERROR'   { 'Red' }
    }

    Write-Host "[$timestamp][$Level] $Message" -ForegroundColor $color
}

# Sprawdza czy polecenie jest dostępne w PATH
function Test-Command {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

# Instaluje pakiet przez winget jeśli nie ma go w systemie
function Install-ViaWinget {
    param(
        [string]$PackageId,
        [string]$Name,
        [string]$TestCommand
    )

    if ($TestCommand -and (Test-Command $TestCommand)) {
        Write-Log "$Name jest już zainstalowane — pomijam" -Level SUCCESS
        return
    }

    if (-not (Test-Command 'winget')) {
        Write-Log "Brak winget — nie mogę automatycznie zainstalować: $Name" -Level ERROR
        exit 1
    }

    if ($PSCmdlet.ShouldProcess($Name, 'Instalacja przez winget')) {
        Write-Log "Instaluję $Name przez winget..."
        winget install --id $PackageId --silent --accept-source-agreements --accept-package-agreements

        if ($LASTEXITCODE -eq 0) {
            Write-Log "$Name zainstalowane poprawnie" -Level SUCCESS
        }
        else {
            Write-Log "Instalacja $Name zakończyła się błędem" -Level ERROR
            exit 1
        }
    }
}

Write-Log 'KROK 1: GitHub CLI' -Level SECTION
Install-ViaWinget -PackageId 'GitHub.cli' -Name 'GitHub CLI' -TestCommand 'gh'

Write-Log 'KROK 2: Rozszerzenie gh-copilot' -Level SECTION

try {
    $extensions = (gh extension list 2>$null) -join "`n"

    if ($extensions -match 'gh-copilot') {
        Write-Log 'Rozszerzenie gh-copilot jest już zainstalowane' -Level SUCCESS
    }
    else {
        if ($PSCmdlet.ShouldProcess('github/gh-copilot', 'Instalacja rozszerzenia gh')) {
            Write-Log 'Instaluję rozszerzenie github/gh-copilot...'
            gh extension install github/gh-copilot

            if ($LASTEXITCODE -eq 0) {
                Write-Log 'Rozszerzenie gh-copilot zainstalowane' -Level SUCCESS
            }
            else {
                Write-Log 'Nie udało się zainstalować rozszerzenia gh-copilot' -Level ERROR
                exit 1
            }
        }
    }
}
catch {
    Write-Log "Błąd podczas sprawdzania/instalacji gh-copilot: $_" -Level ERROR
    exit 1
}

Write-Log 'KROK 3: Weryfikacja działania CLI' -Level SECTION

try {
    $null = gh copilot --help 2>&1
    Write-Log 'Polecenie gh copilot działa poprawnie' -Level SUCCESS
}
catch {
    Write-Log "Polecenie gh copilot nie działa poprawnie: $_" -Level ERROR
    exit 1
}

if (-not $SkipLoginCheck) {
    Write-Log 'KROK 4: Weryfikacja logowania gh' -Level SECTION

    try {
        $null = gh auth status 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Log 'GitHub CLI jest zalogowane' -Level SUCCESS
        }
        else {
            Write-Log 'GitHub CLI nie jest jeszcze zalogowane — uruchom: gh auth login' -Level WARNING
        }
    }
    catch {
        Write-Log 'Nie udało się potwierdzić logowania GH CLI — uruchom ręcznie: gh auth login' -Level WARNING
    }
}

Write-Host ''
Write-Log 'Copilot CLI jest przygotowany do użycia w VS Code' -Level SUCCESS
