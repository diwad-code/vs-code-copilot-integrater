# Bardzo szczegółowa instrukcja wdrożenia konfiguracji VS Code — krok po kroku

Ten dokument prowadzi Cię **bardzo dokładnie**, prostym językiem, przez cały proces.
Zakładam, że chcesz mieć gotowy projekt do pracy w **VS Code + GitHub Copilot + Copilot CLI**
z naciskiem na modele:

- **GPT-5.3-Codex** — do pisania i poprawiania kodu
- **GPT-5.4** — do planowania, analizy, researchu i trudniejszych decyzji

---

## 1. Co dokładnie przygotowuje ten projekt?

Po poprawnym wdrożeniu będziesz mieć:

1. gotowy workspace VS Code,
2. gotowe ustawienia Copilota,
3. rekomendowane rozszerzenia,
4. serwery MCP,
5. działający Copilot CLI (`gh copilot`),
6. skrypty do ustawienia zmiennych środowiskowych,
7. skrypt końcowej weryfikacji,
8. dokumentację opisującą co i jak działa.

---

## 2. Zanim zaczniesz

Przygotuj:

- komputer z **Windows 10/11**,
- konto **GitHub**,
- aktywny **GitHub Copilot Pro+**,
- połączenie z internetem,
- uprawnienia do instalowania programów.

Dodatkowo możesz przygotować:

- `GITHUB_TOKEN` — jeśli chcesz pełne MCP GitHub,
- `BRAVE_API_KEY` — jeśli chcesz research webowy,
- `MAGIC_UI_API_KEY` — jeśli chcesz generowanie UI przez magic-ui.

---

## 3. Pobranie projektu

### Wariant A — przez Git

Otwórz PowerShell i wpisz:

```powershell
git clone https://github.com/diwad-code/vs-code-copilot-integrater.git
cd vs-code-copilot-integrater
code .
```

### Wariant B — jako ZIP

1. Otwórz repozytorium na GitHub.
2. Kliknij **Code**.
3. Kliknij **Download ZIP**.
4. Rozpakuj archiwum.
5. Otwórz folder w VS Code.

---

## 4. Co zrobić zaraz po otwarciu folderu w VS Code?

Po otwarciu projektu:

1. Poczekaj chwilę, aż VS Code wczyta folder.
2. Jeśli zobaczysz komunikat o rekomendowanych rozszerzeniach:
   - kliknij **Install All**.
3. Jeśli VS Code zapyta o zaufanie do folderu:
   - wybierz **Trust the authors** lub odpowiednik.

To ważne, bo bez zaufania część skryptów i integracji może nie działać prawidłowo.

---

## 5. Instalacja środowiska

W projekcie są gotowe skrypty. Uruchamiaj je w tej kolejności.

### Krok 1 — narzędzia systemowe

Uruchom:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
Copy-Item .env.example .env
.\scripts\complete-vscode-setup.ps1
```

Ten skrypt przygotuje lub sprawdzi:

- Git,
- Node.js,
- npm,
- .NET 8,
- PowerShell 7,
- Python,
- GitHub CLI (`gh`).

Jeśli nie chcesz jeszcze ustawiać sekretów, możesz użyć:

```powershell
.\scripts\complete-vscode-setup.ps1 -SkipEnvironmentVariables
```

### Krok 2 — rozszerzenia VS Code

Uruchom:

```powershell
.\scripts\install-extensions.ps1
```

Ten skrypt instaluje rekomendowane rozszerzenia do pracy z:

- Copilotem,
- PowerShellem,
- web development,
- SQL,
- Git,
- dokumentacją.

### Krok 3 — Copilot CLI

Uruchom:

```powershell
.\scripts\install-copilot-cli.ps1
```

Ten skrypt:

- sprawdzi `gh`,
- doinstaluje `gh-copilot`,
- sprawdzi czy polecenie `gh copilot` działa.

### Krok 4 — MCP

Uruchom:

```powershell
.\scripts\install-mcp-servers.ps1
```

To doda serwery MCP, między innymi:

- filesystem,
- github,
- brave-search,
- context7,
- playwright,
- magic-ui.

### Krok 5 — zmienne środowiskowe

Uruchom:

```powershell
.\scripts\set-environment-variables.ps1
```

Skrypt zapyta Cię kolejno o:

- `GITHUB_TOKEN`
- `BRAVE_API_KEY`
- `MAGIC_UI_API_KEY`

Jeśli czegoś jeszcze nie masz, po prostu naciśnij **Enter**, aby pominąć.

Jeżeli wcześniej skopiowałeś `.env.example` do `.env` i wpisałeś tam wartości,
skrypt automatycznie je odczyta i nie będzie trzeba wpisywać wszystkiego od zera.

### Krok 6 — końcowa weryfikacja

Uruchom:

```powershell
.\scripts\verify-vscode-readiness.ps1
```

Ten skrypt pokaże:

- co jest gotowe,
- czego jeszcze brakuje,
- co jest tylko opcjonalne.

---

## 6. Instalacja przez taski VS Code

Jeśli wolisz nie uruchamiać skryptów ręcznie:

1. W VS Code kliknij **Terminal**.
2. Kliknij **Run Task**.
3. Uruchamiaj taski po kolei:
   - `SETUP: Zainstaluj środowisko`
   - `SETUP: Zainstaluj rozszerzenia VS Code`
   - `SETUP: Zainstaluj Copilot CLI`
   - `SETUP: Zainstaluj serwery MCP`
   - `SETUP: Ustaw zmienne środowiskowe`
   - `VERIFY: Sprawdź gotowość workspace`

Możesz też użyć:

- `SETUP: Pełna instalacja`

Potem osobno:

- `SETUP: Ustaw zmienne środowiskowe`
- `VERIFY: Sprawdź gotowość workspace`

---

## 7. Jak pracować z modelami GPT-5.3-Codex i GPT-5.4?

W tym projekcie przyjęto prostą zasadę:

### Używaj **GPT-5.3-Codex**, gdy:

- piszesz kod,
- poprawiasz kod,
- refaktoryzujesz,
- generujesz komendy shell,
- pracujesz szybko i zadaniowo.

### Używaj **GPT-5.4**, gdy:

- planujesz większą zmianę,
- analizujesz architekturę,
- porównujesz technologie,
- robisz research,
- oceniasz ryzyka i edge cases.

### Praktyczna reguła:

1. **Najpierw GPT-5.4** → plan.
2. **Potem GPT-5.3-Codex** → wykonanie.
3. **Na końcu GPT-5.4** → kontrola jakości i decyzja czy rozwiązanie jest kompletne.

### Bardzo praktyczna zasada dla tego repo

- **Copilot Chat + GPT-5.4** → analiza, research, przegląd architektury
- **Copilot Chat + GPT-5.3-Codex** → implementacja zmian w plikach
- **`gh copilot`** → szybkie komendy shell i krótkie podpowiedzi terminalowe

---

## 8. Co sprawdzić ręcznie po wdrożeniu?

Po wszystkim sprawdź ręcznie:

### W VS Code

1. Czy otwiera się panel Copilot Chat.
2. Czy workspace podpowiada rozszerzenia.
3. Czy nie ma błędów w `settings.json`.
4. Czy taski są widoczne w **Run Task**.

### W terminalu

Sprawdź:

```powershell
gh --version
gh copilot --help
node --version
pwsh --version
```

### Dla MCP

Sprawdź, czy istnieje:

```powershell
Test-Path "$env:APPDATA\Code\User\mcp.json"
```

### Dla zmiennych środowiskowych

Sprawdź:

```powershell
[Environment]::GetEnvironmentVariable('GITHUB_TOKEN', 'User')
[Environment]::GetEnvironmentVariable('BRAVE_API_KEY', 'User')
[Environment]::GetEnvironmentVariable('MAGIC_UI_API_KEY', 'User')
```

---

## 9. Najczęstszy bezpieczny scenariusz wdrożenia

Jeśli chcesz po prostu zrobić to dobrze i bez kombinowania, zrób dokładnie to:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\setup-environment.ps1
.\scripts\install-extensions.ps1
.\scripts\install-copilot-cli.ps1
.\scripts\install-mcp-servers.ps1
.\scripts\set-environment-variables.ps1
.\scripts\verify-vscode-readiness.ps1
```

Potem:

1. zamknij VS Code,
2. otwórz VS Code ponownie,
3. otwórz Copilot Chat,
4. sprawdź czy działa `gh copilot`,
5. zacznij pracę.

---

## 10. Co jest opcjonalne, a co obowiązkowe?

### Obowiązkowe:

- VS Code
- GitHub Copilot
- Git
- Node.js
- PowerShell 7
- workspace z tego repo

### Bardzo zalecane:

- GitHub CLI
- gh-copilot
- MCP filesystem
- MCP context7
- MCP sequential-thinking

### Opcjonalne:

- `GITHUB_TOKEN`
- `BRAVE_API_KEY`
- `MAGIC_UI_API_KEY`
- playwright / magic-ui / sqlite — jeśli nie używasz tych funkcji od razu

---

## 11. Kiedy uznać projekt za gotowy?

Projekt możesz uznać za gotowy, gdy:

1. otwiera się poprawnie w VS Code,
2. Copilot działa,
3. `gh copilot --help` działa,
4. taski VS Code są widoczne,
5. plik MCP jest skopiowany,
6. skrypt weryfikacyjny nie pokazuje błędów krytycznych.

---

## 12. Jeśli coś nie działa

Najpierw uruchom ponownie:

1. VS Code,
2. terminal,
3. PowerShell,
4. potem ponownie:

```powershell
.\scripts\verify-vscode-readiness.ps1
```

To jest najszybszy sposób, żeby zobaczyć czego konkretnie brakuje.
