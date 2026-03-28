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

# 3. Skopiuj szablon sekretów i uzupełnij go, jeśli chcesz używać MCP z API keys
Copy-Item .env.example .env

# 4. Uruchom pełny setup (instaluje wszystko automatycznie)
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\complete-vscode-setup.ps1

# 5. Uruchom ponownie VS Code
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
npm install -g @modelcontextprotocol/server-sqlite
npm install -g @playwright/mcp
npm install -g @upstash/context7-mcp
npm install -g @21st-dev/magic-mcp
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

**Najwygodniej:**

```powershell
Copy-Item .env.example .env
.\scripts\set-environment-variables.ps1
```

Jeśli plik `.env` istnieje, skrypt automatycznie odczyta z niego wartości
i zapisze je do zmiennych środowiskowych użytkownika.

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

# MAGIC UI API Key (opcjonalne — dla MCP magic-ui)
# Utwórz na: https://21st.dev
[Environment]::SetEnvironmentVariable(
    'MAGIC_UI_API_KEY',
    'mui_twój_klucz_tutaj',
    'User'
)

# Przeładuj zmienne w PowerShell (bez restartu)
$env:GITHUB_TOKEN = [Environment]::GetEnvironmentVariable('GITHUB_TOKEN', 'User')
$env:BRAVE_API_KEY = [Environment]::GetEnvironmentVariable('BRAVE_API_KEY', 'User')
$env:MAGIC_UI_API_KEY = [Environment]::GetEnvironmentVariable('MAGIC_UI_API_KEY', 'User')
```

---

## 🤖 Copilot CLI (gh-copilot) — konfiguracja pod GPT-5.3-Codex i GPT-5.4

To repo jest przygotowane do pracy z modelami:
- **GPT-5.3-Codex** — implementacja kodu, refaktoryzacja, zadania terminalowe
- **GPT-5.4** — złożone rozumowanie, planowanie, research i decyzje architektoniczne

> Ważne: `gh copilot` nie daje tak precyzyjnego routingu modeli jak Copilot Chat w VS Code.
> Dlatego w praktyce używaj `gh copilot` do szybkich operacji CLI, a przełączanie między
> `GPT-5.3-Codex` i `GPT-5.4` wykonuj głównie w Copilot Chat.

### Instalacja Copilot CLI

```powershell
# 1) Zainstaluj GitHub CLI
winget install --id GitHub.cli --silent --accept-source-agreements --accept-package-agreements

# 2) Dodaj rozszerzenie Copilot do GH CLI
gh extension install github/gh-copilot

# 3) Zaloguj się
gh auth login

# 4) Weryfikacja
gh copilot --help
```

### Szybki workflow CLI

```powershell
# Kodowanie / refaktor (preferuj GPT-5.3-Codex)
gh copilot suggest -t shell "Zaproponuj komendę do ..."

# Analiza i decyzje (przełączaj na GPT-5.4 w Chat/IDE dla głębokiego reasoning)
# W praktyce: użyj GPT-5.4 w Copilot Chat dla planów i researchu,
# a CLI utrzymuj do szybkich operacji kodowo-terminalowych.
```

### VS Code Task

W projekcie dostępny jest task:
- `SETUP: Zainstaluj Copilot CLI`
- `SETUP: Pełna instalacja`

Uruchom: `Terminal > Run Task` i wybierz ten task, aby szybko przygotować CLI.

---

## 🪜 Bardzo dokładna instrukcja wdrożenia

Jeśli chcesz przejść przez cały proces najprostszą możliwą ścieżką, otwórz:

`docs/VS_CODE_STEP_BY_STEP.md`

To jest pełna instrukcja „klik po kliku” i „krok po kroku”, napisana prostym językiem.

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

# Sprawdź gotowość całego workspace
.\scripts\verify-vscode-readiness.ps1
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
