#Requires -Version 5.1
# ============================================================
# NAZWA: verify-vscode-readiness.ps1
# CEL: Ostateczna weryfikacja gotowości projektu do załadowania w VS Code
# UŻYCIE: .\scripts\verify-vscode-readiness.ps1
# WYMAGANIA: PowerShell 5.1+
# ============================================================

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

# Funkcja logująca wynik pojedynczej kontroli
function Write-CheckResult {
    param(
        [string]$Status,
        [string]$Message
    )

    $color = switch ($Status) {
        'PASS' { 'Green' }
        'WARN' { 'Yellow' }
        'FAIL' { 'Red' }
    }

    Write-Host "[$Status] $Message" -ForegroundColor $color
}

# Dodaje wynik do podsumowania końcowego
function Add-Result {
    param(
        [System.Collections.Generic.List[object]]$Results,
        [string]$Status,
        [string]$Message
    )

    $Results.Add([pscustomobject]@{
        Status  = $Status
        Message = $Message
    }) | Out-Null

    Write-CheckResult -Status $Status -Message $Message
}

$workspaceRoot = Split-Path -Path $PSScriptRoot -Parent
$results = New-Object 'System.Collections.Generic.List[object]'

Write-Host ''
Write-Host '=== WERYFIKACJA GOTOWOŚCI VS CODE ===' -ForegroundColor Cyan
Write-Host "Workspace: $workspaceRoot" -ForegroundColor Cyan
Write-Host ''

$requiredFiles = @(
    '.github/copilot-instructions.md',
    '.vscode/settings.json',
    '.vscode/extensions.json',
    '.vscode/tasks.json',
    'mcp/mcp-config.json',
    'README.md',
    'docs/SETUP.md',
    'docs/VS_CODE_STEP_BY_STEP.md',
    '.gitignore',
    'scripts/setup-environment.ps1',
    'scripts/install-extensions.ps1',
    'scripts/install-mcp-servers.ps1',
    'scripts/install-copilot-cli.ps1',
    'scripts/set-environment-variables.ps1',
    'scripts/verify-vscode-readiness.ps1',
    'data/.gitkeep'
)

foreach ($relativePath in $requiredFiles) {
    $fullPath = Join-Path $workspaceRoot $relativePath

    if (Test-Path $fullPath) {
        Add-Result -Results $results -Status 'PASS' -Message "Plik istnieje: $relativePath"
    }
    else {
        Add-Result -Results $results -Status 'FAIL' -Message "Brak pliku: $relativePath"
    }
}

$requiredCommands = @('git', 'node', 'npm', 'pwsh')
foreach ($command in $requiredCommands) {
    if (Get-Command $command -ErrorAction SilentlyContinue) {
        Add-Result -Results $results -Status 'PASS' -Message "Polecenie dostępne: $command"
    }
    else {
        Add-Result -Results $results -Status 'FAIL' -Message "Brak polecenia w PATH: $command"
    }
}

$optionalCommands = @('code', 'gh', 'dotnet')
foreach ($command in $optionalCommands) {
    if (Get-Command $command -ErrorAction SilentlyContinue) {
        Add-Result -Results $results -Status 'PASS' -Message "Polecenie opcjonalne dostępne: $command"
    }
    else {
        Add-Result -Results $results -Status 'WARN' -Message "Polecenie opcjonalne niedostępne: $command"
    }
}

$settingsPath = Join-Path $workspaceRoot '.vscode/settings.json'
$settingsContent = Get-Content $settingsPath -Raw
if ($settingsContent -match 'gpt-5\.3-codex') {
    Add-Result -Results $results -Status 'PASS' -Message 'Domyślny model GPT-5.3-Codex jest ustawiony w settings.json'
}
else {
    Add-Result -Results $results -Status 'FAIL' -Message 'Brak ustawienia GPT-5.3-Codex w settings.json'
}

$setupDocPath = Join-Path $workspaceRoot 'docs/SETUP.md'
$setupDocContent = Get-Content $setupDocPath -Raw
if ($setupDocContent -match 'GPT-5\.4') {
    Add-Result -Results $results -Status 'PASS' -Message 'Dokumentacja opisuje użycie GPT-5.4'
}
else {
    Add-Result -Results $results -Status 'FAIL' -Message 'Brak opisu użycia GPT-5.4 w dokumentacji'
}

$envVars = @('GITHUB_TOKEN', 'BRAVE_API_KEY', 'MAGIC_UI_API_KEY')
foreach ($envVar in $envVars) {
    $value = [Environment]::GetEnvironmentVariable($envVar, 'User')
    if ($value) {
        Add-Result -Results $results -Status 'PASS' -Message "Ustawiona zmienna użytkownika: $envVar"
    }
    else {
        Add-Result -Results $results -Status 'WARN' -Message "Nie ustawiono zmiennej użytkownika: $envVar"
    }
}

if (Get-Command gh -ErrorAction SilentlyContinue) {
    try {
        $extensions = (gh extension list 2>$null) -join "`n"
        if ($extensions -match 'gh-copilot') {
            Add-Result -Results $results -Status 'PASS' -Message 'Rozszerzenie gh-copilot jest zainstalowane'
        }
        else {
            Add-Result -Results $results -Status 'WARN' -Message 'Rozszerzenie gh-copilot nie jest zainstalowane'
        }
    }
    catch {
        Add-Result -Results $results -Status 'WARN' -Message 'Nie udało się sprawdzić rozszerzeń GH CLI'
    }
}

if ($env:APPDATA) {
    $vscodeMcpPath = Join-Path $env:APPDATA 'Code\User\mcp.json'
    if (Test-Path $vscodeMcpPath) {
        Add-Result -Results $results -Status 'PASS' -Message 'Globalny plik MCP dla VS Code istnieje'
    }
    else {
        Add-Result -Results $results -Status 'WARN' -Message 'Brakuje globalnego pliku MCP dla VS Code (Code\\User\\mcp.json)'
    }
}
else {
    Add-Result -Results $results -Status 'WARN' -Message 'Brak zmiennej APPDATA — pomijam sprawdzenie globalnego pliku MCP'
}

$failCount = ($results | Where-Object { $_.Status -eq 'FAIL' }).Count
$warnCount = ($results | Where-Object { $_.Status -eq 'WARN' }).Count
$passCount = ($results | Where-Object { $_.Status -eq 'PASS' }).Count

Write-Host ''
Write-Host '=== PODSUMOWANIE ===' -ForegroundColor Cyan
Write-Host "PASS: $passCount" -ForegroundColor Green
Write-Host "WARN: $warnCount" -ForegroundColor Yellow
Write-Host "FAIL: $failCount" -ForegroundColor Red

if ($failCount -gt 0) {
    Write-Host ''
    Write-Host 'Weryfikacja zakończona błędami krytycznymi.' -ForegroundColor Red
    exit 1
}

Write-Host ''
Write-Host 'Projekt jest gotowy do załadowania do VS Code lub wymaga już tylko opcjonalnych uzupełnień.' -ForegroundColor Green
