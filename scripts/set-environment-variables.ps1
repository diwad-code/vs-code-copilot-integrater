#Requires -Version 5.1
# ============================================================
# NAZWA: set-environment-variables.ps1
# CEL: Interaktywne ustawienie zmiennych środowiskowych dla MCP i Copilota
# UŻYCIE: .\scripts\set-environment-variables.ps1
# WYMAGANIA: PowerShell 5.1+
# ============================================================

[CmdletBinding()]
param(
    # Opcjonalnie: ustaw GITHUB_TOKEN bez pytania interaktywnego
    [Parameter(Mandatory=$false)]
    [string]$GitHubToken,

    # Opcjonalnie: ustaw BRAVE_API_KEY bez pytania interaktywnego
    [Parameter(Mandatory=$false)]
    [string]$BraveApiKey,

    # Opcjonalnie: ustaw MAGIC_UI_API_KEY bez pytania interaktywnego
    [Parameter(Mandatory=$false)]
    [string]$MagicUiApiKey,

    # Pokaż tylko status zmiennych bez modyfikacji
    [Parameter(Mandatory=$false)]
    [switch]$ShowStatusOnly
)

$ErrorActionPreference = 'Stop'

# Zwraca ukrytą postać sekretu do bezpiecznego logowania
function Get-MaskedValue {
    param([string]$Value)

    if (-not $Value) {
        return '[BRAK]'
    }

    if ($Value.Length -le 6) {
        return ('*' * $Value.Length)
    }

    return "{0}{1}" -f $Value.Substring(0, 3), ('*' * ($Value.Length - 3))
}

# Odczytuje wpis użytkownika jako tekst ukryty podczas wpisywania
function Read-SecretValue {
    param([string]$Prompt)

    $secureValue = Read-Host -Prompt $Prompt -AsSecureString
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureValue)

    try {
        return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
    }
    finally {
        if ($ptr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
        }
    }
}

# Ustawia zmienną środowiskową w profilu użytkownika i bieżącej sesji
function Set-UserEnvironmentVariable {
    param(
        [string]$Name,
        [string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return
    }

    [Environment]::SetEnvironmentVariable($Name, $Value, 'User')
    Set-Item -Path "Env:$Name" -Value $Value
}

$variables = @(
    @{
        Name        = 'GITHUB_TOKEN'
        Description = 'Token GitHub do MCP GitHub (opcjonalny, ale zalecany)'
        Value       = $GitHubToken
    },
    @{
        Name        = 'BRAVE_API_KEY'
        Description = 'Klucz Brave Search do researchu webowego (opcjonalny)'
        Value       = $BraveApiKey
    },
    @{
        Name        = 'MAGIC_UI_API_KEY'
        Description = 'Klucz Magic UI do generowania komponentów GUI (opcjonalny)'
        Value       = $MagicUiApiKey
    }
)

Write-Host ''
Write-Host '=== STATUS ZMIENNYCH ŚRODOWISKOWYCH ===' -ForegroundColor Cyan

foreach ($item in $variables) {
    $currentValue = [Environment]::GetEnvironmentVariable($item.Name, 'User')
    Write-Host ("{0,-20} {1}" -f $item.Name, (Get-MaskedValue -Value $currentValue))
}

if ($ShowStatusOnly) {
    return
}

Write-Host ''
Write-Host 'Wciśnij Enter bez wpisywania wartości, jeśli chcesz pominąć daną zmienną.' -ForegroundColor Yellow

foreach ($item in $variables) {
    if (-not $item.Value) {
        $item.Value = Read-SecretValue -Prompt "$($item.Description):"
    }

    if ($item.Value) {
        Set-UserEnvironmentVariable -Name $item.Name -Value $item.Value
        Write-Host "Ustawiono $($item.Name): $(Get-MaskedValue -Value $item.Value)" -ForegroundColor Green
    }
    else {
        Write-Host "Pominięto $($item.Name)" -ForegroundColor Yellow
    }
}

Write-Host ''
Write-Host 'Zmienne środowiskowe zostały zapisane w profilu użytkownika.' -ForegroundColor Green
Write-Host 'Zamknij i otwórz ponownie VS Code, aby wszystkie procesy zobaczyły nowe wartości.' -ForegroundColor Cyan
