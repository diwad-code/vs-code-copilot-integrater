# PowerShell Skill — Definicja umiejętności
# Plik: skills/powershell/skill.yml
# Cel: Definiuje zakres wiedzy i zdolności Copilota dla PowerShell
# Format: Markdown z metadanymi YAML

---
name: "PowerShell Expert"
version: "1.0.0"
description: "Zaawansowane skrypty PowerShell dla automatyzacji Windows, administracji systemem i DevOps"
languages:
  - powershell
tags:
  - automation
  - windows
  - devops
  - scripting
---

## 🎯 Zakres umiejętności PowerShell

### Co potrafię robić:

#### Administracja Systemem Windows
- Zarządzanie usługami Windows (Start-Service, Stop-Service, Restart-Service)
- Konfiguracja rejestru Windows (Get-ItemProperty, Set-ItemProperty)
- Zarządzanie użytkownikami i grupami (AD module, local accounts)
- Monitorowanie wydajności systemu (Get-Process, Get-Counter, WMI/CIM)
- Zarządzanie harmonogramem zadań (ScheduledTasks module)
- Konfiguracja zapory sieciowej (NetSecurity module)

#### Automatyzacja
- Przetwarzanie plików wsadowe (CSV, JSON, XML, Excel)
- Automatyczne backupy z rotacją
- Monitorowanie i alerty (email, Teams webhook, Slack)
- Wdrażanie aplikacji i konfiguracji
- CI/CD pipeline skrypty

#### Active Directory
- Import/eksport użytkowników
- Raportowanie struktury AD
- Automatyczne provisionowanie kont
- Grupowe zarządzanie zasadami GPO

#### Azure / Cloud
- Az module dla Azure PowerShell
- Zarządzanie zasobami Azure
- Azure DevOps integracja

### Wzorce których zawsze używam:

#### Struktura skryptu produkcyjnego:
```powershell
#Requires -Version 5.1
#Requires -Modules @{ ModuleName='PSScriptAnalyzer'; ModuleVersion='1.0' }

[CmdletBinding(SupportsShouldProcess)]
param(...)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Stałe — definiujemy na górze dla łatwej modyfikacji
$Script:LogPath = "$env:TEMP\$(Split-Path -Leaf $MyInvocation.MyCommand.Path .log)"
$Script:Version = '1.0.0'

# Funkcje pomocnicze przed main logiką
function Write-Log { ... }
function Test-Prerequisite { ... }

# Główna logika na dole
try {
    Write-Log "Start skryptu v$Script:Version"
    Test-Prerequisite
    # ... logika
    Write-Log "Sukces" -Level SUCCESS
}
catch {
    Write-Log "Błąd: $_" -Level ERROR
    exit 1
}
finally {
    Write-Log "Koniec skryptu"
}
```

#### Zawsze używam:
- `[CmdletBinding()]` — zaawansowane parametry
- `param()` blok z typowaniem i helpem
- `try/catch/finally` dla obsługi błędów
- Własna funkcja `Write-Log` z timestampem
- `Test-Path` przed dostępem do pliku
- `Where-Object` zamiast pętli for/foreach gdzie możliwe
- Pipeline zamiast zmiennych tymczasowych

### Moduły które znam:
- **PSScriptAnalyzer** — analiza kodu PowerShell
- **Pester** — testy jednostkowe
- **ImportExcel** — praca z plikami Excel bez Office
- **PSFramework** — zaawansowane logowanie i konfiguracja
- **Az** — Azure PowerShell
- **ActiveDirectory** — AD management
- **SqlServer** — SQL Server operations
- **Pode** — serwery HTTP/REST w PowerShell
- **Universal Dashboard** — webowe dashboardy w PowerShell
