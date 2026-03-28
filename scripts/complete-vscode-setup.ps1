#Requires -Version 5.1
# ============================================================
# NAZWA: complete-vscode-setup.ps1
# CEL: Pełne wdrożenie projektu do pracy w VS Code z końcową weryfikacją
# UŻYCIE: .\scripts\complete-vscode-setup.ps1
# WYMAGANIA: PowerShell 5.1+, Windows 10/11, internet
# ============================================================

[CmdletBinding(SupportsShouldProcess)]
param(
    # Pomija interaktywne ustawianie zmiennych środowiskowych
    [Parameter(Mandatory = $false)]
    [switch]$SkipEnvironmentVariables
)

$ErrorActionPreference = 'Stop'

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet('INFO', 'SUCCESS', 'WARNING', 'ERROR', 'SECTION')]
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
        'INFO' { 'Cyan' }
        'SUCCESS' { 'Green' }
        'WARNING' { 'Yellow' }
        'ERROR' { 'Red' }
    }

    Write-Host "[$timestamp][$Level] $Message" -ForegroundColor $color
}

function Invoke-WorkspaceScript {
    param(
        [string]$RelativePath,
        [string[]]$Arguments = @(),
        [bool]$SupportsWhatIf = $false
    )

    $scriptPath = Join-Path $PSScriptRoot $RelativePath

    if (-not (Test-Path $scriptPath)) {
        throw "Nie znaleziono skryptu: $scriptPath"
    }

    $displayName = Split-Path -Path $scriptPath -Leaf
    Write-Log "Uruchamiam: $displayName" -Level INFO

    if ($PSCmdlet.ShouldProcess($displayName, 'Uruchomienie kroku wdrożenia')) {
        $finalArguments = @()

        if ($WhatIfPreference -and $SupportsWhatIf) {
            $finalArguments += '-WhatIf'
        }

        if ($Arguments) {
            $finalArguments += $Arguments
        }

        & $scriptPath @finalArguments
    }
}

Write-Log 'PEŁNE WDROŻENIE WORKSPACE VS CODE' -Level SECTION
Write-Log 'Ten skrypt przygotowuje narzędzia, rozszerzenia, CLI, MCP i końcową weryfikację.' -Level INFO

Invoke-WorkspaceScript -RelativePath 'setup-environment.ps1' -SupportsWhatIf $true
Invoke-WorkspaceScript -RelativePath 'install-extensions.ps1' -SupportsWhatIf $true
Invoke-WorkspaceScript -RelativePath 'install-copilot-cli.ps1' -SupportsWhatIf $true
Invoke-WorkspaceScript -RelativePath 'install-mcp-servers.ps1' -SupportsWhatIf $true

if ($SkipEnvironmentVariables) {
    Write-Log 'Pomijam krok ustawiania zmiennych środowiskowych na życzenie użytkownika.' -Level WARNING
}
else {
    Invoke-WorkspaceScript -RelativePath 'set-environment-variables.ps1'
}

Invoke-WorkspaceScript -RelativePath 'verify-vscode-readiness.ps1'

Write-Host ''
Write-Log 'Pełne wdrożenie projektu do VS Code zakończone.' -Level SUCCESS
Write-Log 'Jeśli ustawiłeś nowe zmienne środowiskowe, zamknij i otwórz ponownie VS Code.' -Level INFO
