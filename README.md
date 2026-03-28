# 🤖 VS Code Copilot Integrater

> **Kompletna konfiguracja GitHub Copilot Pro+ dla VS Code** — gotowa do wrzucenia do
> projektu i natychmiastowego użycia. Zoptymalizowana pod maksymalną produktywność
> deweloperów pracujących z PowerShell, aplikacjami webowymi, SQL/OracleSQL i
> aplikacjami Windows.

---

## ✨ Co zawiera ta konfiguracja?

| Komponent | Opis |
|-----------|------|
| 🧠 **Copilot Instructions** | Globalny system prompt — Copilot wie jak się zachowywać |
| ⚙️ **VS Code Settings** | 200+ ustawień dla maksymalnej produktywności |
| 🔌 **35+ Rozszerzeń** | Lista rekomendowanych rozszerzeń z automatyczną instalacją |
| 🌐 **10 Serwerów MCP** | Narzędzia: pliki, GitHub, wyszukiwarka, baza danych, przeglądarka, UI generation |
| 🎯 **6 Umiejętności** | + Ultimate Engineering (meta-skill) |
| 🤖 **5 Agentów** | + Orchestrator (koordynacja zadań złożonych) |
| 🧩 **Katalog 220+ pozycji** | 120 skills + 70 tools + 30 agents |
| 📜 **3 Skrypty PS + 1 Task CLI** | Automatyczna instalacja środowiska + Copilot CLI readiness |
| 📋 **3 Szablony** | Plan projektu, Worklog, Dokumentacja techniczna |
| 📚 **3 Przewodniki** | Setup, Skills/Agents, Workflows |

---

## 🚀 Szybki start (5 minut)

### Krok 1: Sklonuj lub pobierz

```powershell
git clone https://github.com/diwad-code/vs-code-copilot-integrater.git
cd vs-code-copilot-integrater

# Lub otwórz bezpośrednio w VS Code
code .
```

### Krok 2: Zainstaluj środowisko

```powershell
# Uruchom jako administrator dla pełnej instalacji
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\setup-environment.ps1      # Git, Node.js, .NET 8, PS 7
.\scripts\install-extensions.ps1     # 35+ rozszerzeń VS Code
.\scripts\install-mcp-servers.ps1    # 10 serwerów MCP (w tym magic-ui)
```

### Krok 3: Skonfiguruj GitHub Copilot

1. Upewnij się że masz aktywną subskrypcję **GitHub Copilot Pro+**
2. W VS Code: `Ctrl+Shift+P` → "GitHub Copilot: Sign In"
3. Otwórz Copilot Chat: `Ctrl+Alt+I`
4. Powiedz: **"@workspace Powitaj mnie i powiedz jakie masz możliwości"**

### Krok 3b: Ustaw priorytet modeli (Copilot Chat / CLI)

- **Model domyślny do implementacji:** `GPT-5.3-Codex`
- **Model do złożonego reasoning/research:** `GPT-5.4`
- W `.vscode/settings.json` domyślny model jest ustawiony na `gpt-5.3-codex`.
- Dla zadań analitycznych przełączaj model ręcznie na `gpt-5.4`.

### Krok 3c: Przygotuj Copilot CLI (gh-copilot)

```powershell
# VS Code Task: Terminal > Run Task > SETUP: Copilot CLI (gh-copilot)
# Lub ręcznie:
winget install --id GitHub.cli --silent --accept-source-agreements --accept-package-agreements
gh extension install github/gh-copilot
gh auth login
gh copilot --help
```

### Krok 4: Ustaw zmienne środowiskowe (opcjonalne, dla MCP)

```powershell
# GitHub Token (dla MCP GitHub) — https://github.com/settings/tokens
[Environment]::SetEnvironmentVariable('GITHUB_TOKEN', 'ghp_...', 'User')

# Brave Search Key (dla MCP search) — https://brave.com/search/api
[Environment]::SetEnvironmentVariable('BRAVE_API_KEY', 'BSA...', 'User')
```

Pełna instrukcja: [docs/SETUP.md](docs/SETUP.md)

---

## 📁 Struktura projektu

```
vs-code-copilot-integrater/
│
├── .github/
│   ├── copilot-instructions.md    ← 🧠 System prompt Copilota (KLUCZOWY PLIK)
│   └── ISSUE_TEMPLATE/
│
├── .vscode/
│   ├── settings.json              ← ⚙️ Ustawienia VS Code + Copilot
│   ├── extensions.json            ← 🔌 Rekomendowane rozszerzenia
│   └── tasks.json                 ← ▶️ Zadania automatyzacji (Ctrl+Shift+B)
│
├── mcp/
│   └── mcp-config.json            ← 🌐 Konfiguracja serwerów MCP
│
├── skills/
│   ├── powershell/skill.md        ← 🖥️ Ekspert PowerShell
│   ├── web-development/skill.md   ← 🌐 Ekspert Web Dev
│   ├── database/skill.md          ← 🗄️ Ekspert SQL/Oracle
│   ├── gui-design/skill.md        ← 🎨 Ekspert GUI Design
│   └── windows-apps/skill.md      ← 🪟 Ekspert Windows Apps
│   └── ultimate-engineering/skill.md ← 🧠 Meta-skill 120+ umiejętności
│
├── agents/
│   ├── planning-agent.md          ← 📐 Agent planowania projektów
│   ├── documentation-agent.md     ← 📚 Agent dokumentowania
│   ├── code-review-agent.md       ← 🔍 Agent code review
│   └── research-agent.md          ← 🔬 Agent badania technologii
│   └── orchestrator-agent.md      ← 🎛️ Agent orkiestracji pracy
│
├── docs/
│   ├── SETUP.md                   ← 📖 Instrukcja instalacji
│   ├── SKILLS_AND_AGENTS.md       ← 🛠️ Przewodnik po skillach i agentach
│   └── DEVELOPMENT_WORKFLOWS.md   ← 🔄 Przepływy pracy
│   └── ULTIMATE_SKILLS_TOOLS_AGENTS_CATALOG.md ← 📚 Katalog 220+
│
├── scripts/
│   ├── setup-environment.ps1      ← 🔧 Instalacja środowiska
│   ├── install-extensions.ps1     ← 🔌 Instalacja rozszerzeń VS Code
│   └── install-mcp-servers.ps1    ← 🌐 Instalacja serwerów MCP
│
├── templates/
│   ├── project-plan-template.md   ← 📋 Szablon planu projektu
│   ├── worklog-template.md        ← 📝 Szablon dziennika pracy
│   └── project-docs-template.md   ← 📚 Szablon dokumentacji technicznej
│
├── WORKLOG.md                     ← 📅 Dziennik pracy nad tym projektem
└── README.md                      ← Jesteś tutaj
```

---

## 🧠 Kluczowy plik: copilot-instructions.md

Plik `.github/copilot-instructions.md` to **globalny system prompt** który GitHub Copilot
automatycznie odczytuje w VS Code. Definiuje on:

### Jak Copilot się zachowuje:
- ✅ **Zawsze pyta** o szczegóły przed implementacją
- ✅ **Planuje** każdy projekt przed kodowaniem
- ✅ **Komentuje** każdą linię kodu po polsku
- ✅ **Aktualizuje** WORKLOG.md po każdej sesji
- ✅ **Rekomenduje** nowoczesne, sprawdzone technologie
- ✅ **Tworzy** piękne, dostępne GUI
- ✅ **Pilnuje** bezpieczeństwa (brak hardkodowanych sekretów)

### Obszary specjalizacji:
| Obszar | Technologie |
|--------|-------------|
| **PowerShell** | PS 5.1/7, PSScriptAnalyzer, Pester, PSFramework |
| **Web Apps** | React 18, Vue 3, TypeScript, Tailwind CSS, Vite |
| **Bazy danych** | SQL Server (T-SQL), Oracle (PL/SQL) |
| **GUI Design** | Tailwind, shadcn/ui, Framer Motion, dark theme |
| **Windows Apps** | WPF, WinForms, .NET 8, CommunityToolkit.Mvvm |

---

## 🌐 Serwery MCP (Model Context Protocol)

MCP rozszerza możliwości Copilota o dostęp do narzędzi zewnętrznych:

| Serwer | Co daje Copilotowi | Wymagania |
|--------|-------------------|-----------|
| `filesystem` | Czytanie i pisanie plików | Brak |
| `memory` | Pamięć kontekstu między sesjami | Brak |
| `sequential-thinking` | Planowanie kroków | Brak |
| `github` | Dostęp do GitHub API | `GITHUB_TOKEN` |
| `brave-search` | Wyszukiwanie aktualnych informacji | `BRAVE_API_KEY` |
| `puppeteer` | Automatyzacja Chrome, screenshoty | Brak |
| `sqlite` | Lokalna baza do testów | Brak |
| `context7` | Aktualna dokumentacja frameworków | Brak |
| `playwright` | Testy E2E przeglądarkowe | Brak |
| `magic-ui` | Generowanie komponentów GUI | `MAGIC_UI_API_KEY` (opcjonalny) |

---

## 💡 Przykłady użycia

### Planowanie projektu:
```
"Zaplanuj aplikację webową do zarządzania zamówieniami.
Backend: .NET Core, baza: SQL Server, frontend: React"
```
*Copilot zada pytania wyjaśniające i stworzy kompletny plan przed implementacją*

### Skrypt PowerShell:
```
"Napisz skrypt PS który automatycznie tworzy backupy folderów z rotacją 30 dni,
logowaniem do pliku i powiadomieniem email w razie błędu"
```
*Copilot napisze kompletny skrypt z obsługą błędów i komentarzami po polsku*

### Nowoczesne GUI:
```
"Stwórz landing page dla SaaS z: hero section z gradientem, sekcja features,
pricing cards, dark mode, animacje — Tailwind CSS"
```
*Copilot stworzy piękny, nowoczesny interfejs z responsywnością i animacjami*

### SQL Stored Procedure:
```
"Napisz stored procedure T-SQL do raportowania sprzedaży z paginacją,
filtrowaniem po dacie i kliencie, obsługą błędów"
```
*Copilot napisze procedurę z komentarzami, SET NOCOUNT, BEGIN TRY/CATCH*

---

## 📋 Przepływy pracy (Workflows)

Szczegółowe przepływy pracy w [docs/DEVELOPMENT_WORKFLOWS.md](docs/DEVELOPMENT_WORKFLOWS.md):

- 🆕 Nowy projekt (planowanie → implementacja → dokumentacja)
- 🖥️ Skrypt PowerShell (wzorzec produkcyjny)
- 🌐 Aplikacja webowa (React/Vue + Tailwind)
- 🗄️ Baza danych (SQL/Oracle — procedury, widoki, indeksy)
- 🪟 Aplikacja Windows (.NET, WPF/WinForms)
- 🔄 Code Review
- 📝 Dokumentacja

---

## 🔒 Bezpieczeństwo

Ta konfiguracja jest zaprojektowana z bezpieczeństwem jako priorytetem:

- ❌ Nigdy nie generuje hardkodowanych haseł/kluczy/sekretów
- ✅ Zawsze używa zmiennych środowiskowych lub Key Vault
- ✅ SQL tylko z parametrami (bez konkatenacji stringów)
- ✅ Walidacja danych wejściowych od użytkownika
- ✅ Content Security Policy dla aplikacji web
- ✅ Zasada najmniejszych uprawnień

---

## 🤝 Jak rozszerzać tę konfigurację?

### Dodaj nowy skill:
```
skills/
└── mój-nowy-skill/
    └── skill.md   ← Opisz obszar wiedzy i wzorce kodu
```

### Dodaj nowy serwer MCP:
1. Zainstaluj: `npm install -g @nazwa/pakietu-mcp`
2. Dodaj do `mcp/mcp-config.json` w sekcji `servers`
3. Zaktualizuj `scripts/install-mcp-servers.ps1`

### Dostosuj instrukcje Copilota:
Edytuj `.github/copilot-instructions.md` — Copilot odczyta zmiany natychmiast

### Użyj kompletnego katalogu:
- `docs/ULTIMATE_SKILLS_TOOLS_AGENTS_CATALOG.md` zawiera:
  - **120 skills** (programowanie, reasoning, research)
  - **70 tools** (IDE, CI/CD, security, data, AI/MCP)
  - **30 agent roles** (od planowania po AI eval i incident response)

---

## 📋 Wymagania

| Wymaganie | Wersja |
|-----------|--------|
| Windows | 10 22H2+ / 11 |
| VS Code | 1.95+ |
| GitHub Copilot | **Pro+** (wymagane) |
| Node.js | 18 LTS+ |
| PowerShell | 7.4+ |
| .NET SDK | 8.0 LTS |
| Git | 2.40+ |

---

## 📄 Licencja

MIT License — Używaj swobodnie, modyfikuj i dostosuj do swoich potrzeb.

---

## 🙋 Wsparcie

Jeśli masz pytania lub problemy:
1. Sprawdź [docs/SETUP.md](docs/SETUP.md) — sekcja "Rozwiązywanie problemów"
2. Otwórz Issue w tym repozytorium
3. W Copilot Chat: "Mam problem z [opis]. Jak rozwiązać?"

---

*Dokumentacja zaktualizowana: 2026-03-28*
