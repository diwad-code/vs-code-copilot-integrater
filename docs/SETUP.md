# Dokumentacja: Przewodnik instalacji i konfiguracji
# Plik: docs/SETUP.md
# CEL: Krok po kroku instrukcja przygotowania środowiska

# 🚀 Przewodnik instalacji i konfiguracji

Ten dokument opisuje jak skonfigurować kompletne środowisko deweloperskie
z GitHub Copilot Pro+ zoptymalizowane pod specyfikę tego projektu.

---

## 📋 Wymagania wstępne

### Wymagane oprogramowanie:
| Oprogramowanie | Minimalna wersja | Pobierz |
|---------------|-----------------|---------|
| Windows | 10 (22H2) lub 11 | — |
| VS Code | 1.95+ | https://code.visualstudio.com |
| Node.js | 18 LTS | https://nodejs.org |
| Git | 2.40+ | https://git-scm.com |
| PowerShell | 7.4+ | https://aka.ms/powershell |
| .NET SDK | 8.0 LTS | https://dot.net |

### Wymagane konta:
- **GitHub** z aktywną subskrypcją **Copilot Pro+**
- **Brave Search API** (darmowy plan) — https://brave.com/search/api
- Opcjonalnie: **GitHub Personal Access Token** dla MCP GitHub

---

## ⚡ Szybka instalacja (automatyczna)

```powershell
# 1. Otwórz PowerShell jako administrator
# 2. Przejdź do folderu projektu
cd C:\Projekty\vs-code-copilot-integrater

# 3. Uruchom pełny setup (instaluje wszystko automatycznie)
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\setup-environment.ps1   # Narzędzia deweloperskie
.\scripts\install-extensions.ps1  # Rozszerzenia VS Code
.\scripts\install-mcp-servers.ps1 # Serwery MCP

# 4. Uruchom ponownie VS Code
```

---

## 🔧 Instalacja manualna (krok po kroku)

### Krok 1: VS Code

1. Pobierz i zainstaluj VS Code: https://code.visualstudio.com
2. Otwórz terminal w VS Code (`` Ctrl+` ``)
3. Sprawdź czy `code` jest dostępne w PATH:
   ```powershell
   code --version
   ```
   Jeśli nie — `Ctrl+Shift+P` → "Shell Command: Install 'code' command in PATH"

### Krok 2: GitHub Copilot Pro+

1. Zaloguj się do GitHub.com i przejdź do: https://github.com/settings/copilot
2. Aktywuj subskrypcję **Copilot Pro+** (lub **Enterprise** jeśli w organizacji)
3. W VS Code: `Ctrl+Shift+P` → "GitHub Copilot: Sign In"
4. Autoryzuj aplikację na GitHub.com

**Weryfikacja:** Ikona Copilota w prawym dolnym rogu VS Code powinna być zielona.

### Krok 3: Rozszerzenia VS Code

**Automatycznie:** Po otwarciu projektu VS Code wyświetli powiadomienie
"This workspace has extension recommendations" — kliknij "Install All".

**Manualnie:**
```powershell
# Uruchom skrypt instalacji rozszerzeń
.\scripts\install-extensions.ps1
```

**Lub ręcznie** — dla każdego rozszerzenia z `.vscode/extensions.json`:
```
Ctrl+Shift+X → wyszukaj identyfikator → Install
```

### Krok 4: Serwery MCP (rozszerzenie możliwości Copilota)

MCP (Model Context Protocol) to protokół który daje Copilotowi dostęp do
narzędzi zewnętrznych — plików, wyszukiwarki, bazy danych itp.

```powershell
# Instalacja serwerów MCP
.\scripts\install-mcp-servers.ps1

# Lub manualnie:
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-memory
npm install -g @modelcontextprotocol/server-sequential-thinking
npm install -g @modelcontextprotocol/server-brave-search
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-puppeteer
npm install -g @upstash/context7-mcp
```

**Konfiguracja VS Code dla MCP:**
1. Skopiuj zawartość `mcp/mcp-config.json` (sekcję `servers`)
2. Otwórz `Ctrl+Shift+P` → "Open User Settings (JSON)"
3. Dodaj sekcję `mcp` z konfiguracją serwerów

**Lub** skopiuj plik konfiguracyjny:
```powershell
# Ścieżka konfiguracyjna MCP dla VS Code
Copy-Item mcp\mcp-config.json "$env:APPDATA\Code\User\mcp.json"
```

### Krok 5: Zmienne środowiskowe

Ustaw wymagane zmienne środowiskowe (niezbędne dla niektórych MCP serwerów):

```powershell
# GitHub Personal Access Token (zakres: repo, read:user)
# Utwórz na: https://github.com/settings/tokens
[Environment]::SetEnvironmentVariable(
    'GITHUB_TOKEN',
    'ghp_twój_token_tutaj',
    'User'
)

# Brave Search API Key (darmowy plan: 2000 req/miesiąc)
# Utwórz na: https://brave.com/search/api
[Environment]::SetEnvironmentVariable(
    'BRAVE_API_KEY',
    'BSA_twój_klucz_tutaj',
    'User'
)

# Przeładuj zmienne w PowerShell (bez restartu)
$env:GITHUB_TOKEN = [Environment]::GetEnvironmentVariable('GITHUB_TOKEN', 'User')
$env:BRAVE_API_KEY = [Environment]::GetEnvironmentVariable('BRAVE_API_KEY', 'User')
```

---

## ✅ Weryfikacja instalacji

Po zakończeniu instalacji sprawdź czy wszystko działa:

```powershell
# Sprawdź wersje narzędzi
Write-Host "=== Wersje narzędzi ===" -ForegroundColor Cyan
git --version
node --version
npm --version
dotnet --version
pwsh --version

# Sprawdź zainstalowane moduły PS
Write-Host "`n=== Moduły PowerShell ===" -ForegroundColor Cyan
Get-Module -ListAvailable PSScriptAnalyzer, Pester, ImportExcel | Select Name, Version

# Sprawdź zainstalowane pakiety MCP
Write-Host "`n=== Pakiety MCP ===" -ForegroundColor Cyan
npm list -g --depth=0 2>$null | Select-String "modelcontextprotocol|context7|playwright"
```

**W VS Code:**
1. Otwórz Copilot Chat (`` Ctrl+Alt+I ``)
2. Wpisz: `@workspace Cześć! Jakie narzędzia MCP masz dostępne?`
3. Copilot powinien wymienić dostępne serwery MCP

---

## 🆘 Rozwiązywanie problemów

### Problem: Copilot nie odpowiada / brak sugestii
1. Sprawdź czy masz aktywną subskrypcję: https://github.com/settings/copilot
2. Wyloguj i zaloguj ponownie: `Ctrl+Shift+P` → "GitHub Copilot: Sign Out" → Sign In
3. Sprawdź połączenie z internetem i czy GitHub nie ma outage: https://githubstatus.com

### Problem: MCP serwery nie działają
1. Sprawdź czy Node.js jest zainstalowany: `node --version`
2. Sprawdź czy pakiety są zainstalowane globalnie: `npm list -g --depth=0`
3. Sprawdź plik konfiguracyjny: `%APPDATA%\Code\User\mcp.json`
4. Sprawdź logi VS Code: `Help > Toggle Developer Tools > Console`

### Problem: Rozszerzenia nie instalują się
1. Sprawdź połączenie z internetem
2. Sprawdź czy marketplace nie jest zablokowany przez firewall firmowy
3. Spróbuj zainstalować ręcznie przez VS Code: `Ctrl+Shift+X`
4. Sprawdź czy `code --version` działa w terminalu

### Problem: Błędy w skryptach PowerShell
```powershell
# Sprawdź Execution Policy
Get-ExecutionPolicy -List

# Ustaw dla bieżącego procesu (nie wymaga admina)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```
